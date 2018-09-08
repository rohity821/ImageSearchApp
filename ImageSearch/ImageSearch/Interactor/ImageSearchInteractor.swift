//
//  ImageSearchInteractor.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation

protocol ImageSearchInteractorDelegate {
    func searchQueryErrorRecieved(errorMsg : String)
    func searchQueryDidComplete(imageResponse:ImageResponseModel)
}

protocol ImageSearchInteractorInterfaceProtocol {
    func getResultsForSearch(searchQuery:String)
    func getNextPageForSearch(searchQuery:String)
}

class ImageSearchInteractor : NSObject, ImageSearchInteractorInterfaceProtocol  {
    
    var page : Int = 0
    var delegate : ImageSearchInteractorDelegate?
    
    let searchQueryTask = ImageSearchQueryTask()
    
    
    func getResultsForSearch(searchQuery:String) {
        page = 1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    func getNextPageForSearch(searchQuery:String) {
        if !ReachabilityManager.shared.isNetworkAvailable {
            //It is returned because pagination wont work when network is not available.
            return
        }
        page = page+1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    private func getResultsForSearch(searchQuery:String, page:Int) {
        let finalQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        if finalQuery.isEmpty {
            return
        }
        
        if !ReachabilityManager.shared.isNetworkAvailable {
            getDataFromLocalStorage(searchQuery: finalQuery)
        }
        else {
        searchQueryTask.getSearchResults(searchTerm: finalQuery, page: page) { [weak self] (imageResponse, errorMessage) in
            if let imgResponse = imageResponse {
                if let response = imgResponse.dictionary {
                    self?.saveImageHits(dictionary: response, searchQuery: finalQuery, page: page)
                }
                self?.delegate?.searchQueryDidComplete(imageResponse: imgResponse)
            } else if !errorMessage.isEmpty {
                self?.delegate?.searchQueryErrorRecieved(errorMsg: errorMessage)
            }
        }
        }
    }

    private func saveImageHits(dictionary:[String: Any], searchQuery:String, page:Int) {
        let shouldAppend = page != 1
        debugPrint("****shoud append value \(shouldAppend)")
        if let hitsArr = dictionary["hits"] as? [[String:Any]], hitsArr.count > 0 {
            WriterTask.shared().saveDataToPlist(response: hitsArr, forKey: searchQuery, shouldAppend: shouldAppend)
        }
    }
    
    private func getSavedImages(searchQuery:String) -> [[String:Any]]? {
        return WriterTask.shared().getDataForKey(key: searchQuery)
    }
    
    private func getDataFromLocalStorage(searchQuery:String) {
            if let data = getSavedImages(searchQuery: searchQuery) {
                let dictionary : [String:Any] = ["hits":data]
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted )
                    let decoder = JSONDecoder()
                    let imgResponse = try decoder.decode(ImageResponseModel.self, from: jsonData)
                    delegate?.searchQueryDidComplete(imageResponse: imgResponse)
                }   
                catch let parseError as NSError {
                    debugPrint("\(parseError.localizedDescription)")
                    delegate?.searchQueryErrorRecieved(errorMsg: technicalError)
                }
            } else {
                delegate?.searchQueryErrorRecieved(errorMsg: noInternetError)
            }
    }
    
}
