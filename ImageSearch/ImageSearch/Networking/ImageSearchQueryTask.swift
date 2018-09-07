//
//  ImageSearchQueryTask.swift
//  ImageSearch
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation

class ImageSearchQueryTask {
    typealias JSONDictionary = [String: Any]
    typealias result = (ImageResponseModel?, String) -> ()
    
    let baseUrl = "https://pixabay.com/api/?key=10028201-f7ffd1c4b91bb9627b124a7b9&q=yellow+flowers&image_type=photo&pretty=true&per_page=20"
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var imageResults: ImageResponseModel?
    var errorMessage = ""
    
    let perPage = 20
    
    func getSearchResults(searchTerm: String,page:Int, completion: @escaping result) {
        dataTask?.cancel()
        if var urlComponents = URLComponents(string: ImageSearchAPI.imageSearchUrl) {
            urlComponents.query = "key=10028201-f7ffd1c4b91bb9627b124a7b9&image_type=photo&pretty=true&q=\(searchTerm)&per_page=\(perPage)&page=\(page)"
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateSearchResults(data)
                    DispatchQueue.main.async {
                        completion(self.imageResults, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    private func updateSearchResults(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ImageResponseModel.self, from: data)
            print(response.hits[0].pageURL)
            imageResults = response
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            print("\(errorMessage)")
            return
        }
    }
    
}


