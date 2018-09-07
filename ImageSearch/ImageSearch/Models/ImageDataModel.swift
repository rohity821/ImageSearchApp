//
//  ImageDataModel.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation

struct ImageResponseModel : Codable {
    struct ImageDataModel : Codable {
        let largeImageURL : String
        let id : Int
        let pageURL : String
        let type : String
        let userImageURL : String
        let previewURL : String
    }
    
    let totalHits : Int
    let hits : [ImageDataModel]
    var total : Int
}


/*
 {
 "largeImageURL": "https://pixabay.com/get/ea34b00c2bf5093ed1584d05fb1d4796e375ead719b00c4090f3c778a1eeb4b9d0_1280.jpg",
 "webformatHeight": 426,
 "webformatWidth": 640,
 "likes": 664,
 "imageWidth": 2736,
 "id": 3113318,
 "user_id": 7410713,
 "views": 263849,
 "comments": 110,
 "pageURL": "https://pixabay.com/en/sunflower-nature-flora-flower-3113318/",
 "imageHeight": 1824,
 "webformatURL": "https://pixabay.com/get/ea34b00c2bf5093ed1584d05fb1d4796e375ead719b00c4090f3c778a1eeb4b9d0_640.jpg",
 "type": "photo",
 "previewHeight": 99,
 "tags": "sunflower, nature, flora",
 "downloads": 170660,
 "user": "bichnguyenvo",
 "favorites": 424,
 "imageSize": 1026006,
 "previewWidth": 150,
 "userImageURL": "https://cdn.pixabay.com/user/2017/12/16/10-28-39-199_250x250.jpg",
 "previewURL": "https://cdn.pixabay.com/photo/2018/01/28/11/24/sunflower-3113318_150.jpg"
 }
 
 */
