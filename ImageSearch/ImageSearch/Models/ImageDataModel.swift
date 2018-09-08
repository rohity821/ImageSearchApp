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
        
        var dictionary: [String: Any]? {
            guard let data = try? JSONEncoder().encode(self) else { return nil }
            return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
        }
    }
    
    let totalHits : Int?
    let hits : [ImageDataModel]
    var total : Int?
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
