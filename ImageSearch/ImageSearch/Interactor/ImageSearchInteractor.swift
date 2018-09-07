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
        page = page+1
        getResultsForSearch(searchQuery: searchQuery, page: page)
    }
    
    private func getResultsForSearch(searchQuery:String, page:Int) {
        let finalQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        if finalQuery.isEmpty {
            return
        }
        searchQueryTask.getSearchResults(searchTerm: finalQuery, page: page) { [weak self] (imageResponse, errorMessage) in
            if let imgResponse = imageResponse {
                self?.delegate?.searchQueryDidComplete(imageResponse: imgResponse)
            } else if !errorMessage.isEmpty {
                self?.delegate?.searchQueryErrorRecieved(errorMsg: errorMessage)
            }
        }
    }
    
}
