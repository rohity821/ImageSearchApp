//
//  ImageCollectionCell.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import UIKit
import SDWebImage

class ImageCollectionCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func setImage(imagePath:String) {
        let url = URL(string: imagePath)
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
    
}
