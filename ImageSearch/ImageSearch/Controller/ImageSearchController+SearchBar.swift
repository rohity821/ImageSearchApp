//
//  ImageSearchController+SearchBarDelegate.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation
import UIKit
import PKHUD

extension ImageSearchController : UISearchBarDelegate {
    
    @objc func dismissKeyboard() {
        navigationItem.searchController?.isActive = false
        navigationItem.searchController?.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            dismissKeyboard()
            removeObjectsFromCollectionDatasource()
            showTextHUD()
            updateSearchQuery(query: searchText)
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            searchPresenter.refreshDataWithSearchQuery(searchQuery: searchText)
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        view.removeGestureRecognizer(tapRecognizer)
    }
}


extension ImageSearchController {
    func showTextHUD() {
        DispatchQueue.main.async {
            HUD.dimsBackground = false
            HUD.allowsInteraction = false
            HUD.show(.progress, onView: self.view)
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            HUD.hide(animated: true)
        }
    }
}

extension ImageSearchController {
    func showToast(title:String) {
        DispatchQueue.main.async {
            self.view.makeToast(title)
        }
    }
}
