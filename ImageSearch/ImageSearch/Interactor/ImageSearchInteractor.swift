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

class ImageSearchInteractor  {
    
    var page : Int = 0
    var delegate : ImageSearchInteractorDelegate?
    
    let searchQueryTask = ImageSearchQueryTask()
    
    
    func getResultsForSearch(searchQuery:String) {
        page = page+1
        let finalQuery = searchQuery.replacingOccurrences(of: " ", with: "+")
        if finalQuery.isEmpty {
            return
        }
        searchQueryTask.getSearchResults(searchTerm: finalQuery, page: page) { [weak self] (imageResponse, errorMessage) in
            if !errorMessage.isEmpty {
                self?.delegate?.searchQueryErrorRecieved(errorMsg: errorMessage)
            } else if let imgResponse = imageResponse {
                self?.delegate?.searchQueryDidComplete(imageResponse: imgResponse)
            }
        }
    }
    
}
