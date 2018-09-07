//
//  ImageSearchController.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import UIKit

class ImageSearchController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageSearchPresenterDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var layoutType : GridLayoutType = .twoByTwo
    internal var searchPresenter = ImageSearchPresenter()
    private var images = [ImageResponseModel.ImageDataModel]()
    
    @IBOutlet weak var optionsBtn: UIBarButtonItem!
    lazy var tapRecognizer: UITapGestureRecognizer = {
        var recognizer = UITapGestureRecognizer(target:self, action: #selector(dismissKeyboard))
        return recognizer
    }()
    
    @IBOutlet weak var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view, typically from a nib.
        title = "Image Search"
        setupSearchBar()
        searchPresenter.presenterDelegate = self
        toggleOptionBtnState()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.searchController?.searchBar.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Functions
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    //MARK: UICollection View Datasource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ImageCollectionCell {
            if images.count > indexPath.row {
                let model = images[indexPath.row]
                cell.setImage(imagePath: model.previewURL)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem(collectionView: collectionView)
    }
    
    //MARK: UICollection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    //Mark: Private functions
    private func sizeForItem(collectionView: UICollectionView) -> CGSize {
        let width = collectionView.frame.size.width
        let sidePadding : CGFloat = 8.0
        var noOfPadding : CGFloat = 3.0
        var noOfCells : CGFloat = 2.0
        switch layoutType {
        case .twoByTwo:
            noOfCells = 2
            noOfPadding = noOfCells+2
        case .threeByThree:
            noOfCells = 3
            noOfPadding = noOfCells+2
        case .fourByFour:
            noOfCells = 4
            noOfPadding = noOfCells+2
        }
        let itemW = (width - (noOfPadding * sidePadding))/noOfCells
        let size = CGSize(width: itemW, height: itemW)
        return size
    }
    
    private func changeLayoutAndReload(layout:GridLayoutType) {
        layoutType = layout
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func toggleOptionBtnState() {
        navigationItem.rightBarButtonItem?.isEnabled = images.count > 0
    }
    
    internal func removeObjectsFromCollectionDatasource() {
        images.removeAll()
    }
    
    @IBAction func optionsButtonClicked(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "Change Layout", message: nil, preferredStyle: .actionSheet)
        let twoAction = UIAlertAction(title: "2X2", style: .default) {[weak self] _ in
            self?.changeLayoutAndReload(layout: .twoByTwo)
            
        }
        let threeAction = UIAlertAction(title: "3X3", style: .default) { [weak self] _ in
            self?.changeLayoutAndReload(layout: .threeByThree)
        }
        let fourAction = UIAlertAction(title: "4X4", style: .default) { [weak self]_ in
            self?.changeLayoutAndReload(layout: .fourByFour)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(twoAction)
        actionSheet.addAction(threeAction)
        actionSheet.addAction(fourAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //Mark : Image search presenter delegate
    func refreshUIForSearchResults(searchResults: ImageResponseModel) {
        hideHUD()
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        if searchResults.hits.count == 0 && images.count == 0 {
            DispatchQueue.main.async { [weak self] in
                self?.noDataView.isHidden = false
                self?.collectionView.isHidden = true
            }
        } else {
            if images.count == 0 {
                images = searchResults.hits
            } else {
                images.append(contentsOf: searchResults.hits)
            }
            DispatchQueue.main.async { [weak self] in
                self?.noDataView.isHidden = true
                self?.collectionView.isHidden = false
                self?.collectionView.reloadData()
            }
        }
        toggleOptionBtnState()
    }
    
    func refreshUIforSearchResultsFailure(errorMessage: String) {
        hideHUD()
        showToast(title: errorMessage)
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if self.images.count == 0 {
                self.noDataView.isHidden = false
                self.collectionView.isHidden = true
            } else {
                self.noDataView.isHidden = true
                self.collectionView.isHidden = false
                //show toast or alert
            }
            self.toggleOptionBtnState()
        }
    }
}
