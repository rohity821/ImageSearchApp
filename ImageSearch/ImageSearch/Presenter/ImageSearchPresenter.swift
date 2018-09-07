//
//  ImageSearchPresenter.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation

protocol ImageSearchPresenterInterfaceProtocol {
    func refreshDataWithSearchQuery(searchQuery:String)
    func getNextPage()
}

protocol ImageSearchPresenterDelegate {
    func refreshUIForSearchResults(searchResults:ImageResponseModel)
    func refreshUIforSearchResultsFailure(errorMessage:String)
}

class ImageSearchPresenter :ImageSearchPresenterInterfaceProtocol, ImageSearchInteractorDelegate {
    
    var presenterDelegate : ImageSearchPresenterDelegate?
    var searchInteractor = ImageSearchInteractor()
    var searchQuery = ""
    
    func refreshDataWithSearchQuery(searchQuery: String) {
        searchInteractor.delegate = self;
        self.searchQuery = searchQuery
        searchInteractor.getResultsForSearch(searchQuery: searchQuery)
    }
    
    func getNextPage() {
        if searchQuery.isEmpty {
            return
        }
        searchInteractor.getNextPageForSearch(searchQuery: searchQuery)
    }
    
    //Mark : ImageSearchInteractorDelegate
    func searchQueryErrorRecieved(errorMsg: String) {
        presenterDelegate?.refreshUIforSearchResultsFailure(errorMessage: errorMsg)
    }
    
    func searchQueryDidComplete(imageResponse: ImageResponseModel) {
        presenterDelegate?.refreshUIForSearchResults(searchResults: imageResponse)
    }
}

