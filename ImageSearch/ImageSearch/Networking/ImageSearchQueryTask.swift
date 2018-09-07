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
    
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var imageResults: ImageResponseModel?
    var errorMessage = ""
    
    let perPage = 40
    
    func getSearchResults(searchTerm: String,page:Int, completion: @escaping result) {
        dataTask?.cancel()
        
        
        if !ReachabilityManager.shared.isNetworkAvailable {
            if let data = readData(fromFile: searchTerm) {
                updateSearchResults(data)
            } else {
                errorMessage = noInternetError
            }
            completion(imageResults, errorMessage)
            resetLocalVariables()
        }
        else {
            if var urlComponents = URLComponents(string: ImageSearchAPI.imageSearchUrl) {
                urlComponents.query = "key=\(apiKey)&image_type=photo&pretty=true&q=\(searchTerm)&per_page=\(perPage)&page=\(page)"
                guard let url = urlComponents.url else { return }
                
                dataTask = defaultSession.dataTask(with: url) { data, response, error in
                    defer { self.dataTask = nil }
                    if let error = error {
                        self.errorMessage += "DataTask error: " + error.localizedDescription + "\n"
                    } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        self.updateSearchResults(data)
                        self.saveData(data: data, toFile: searchTerm)
                    } else {
                        self.errorMessage = noContentsToShow
                    }
                    completion(self.imageResults, self.errorMessage)
                    self.resetLocalVariables()
                }
                dataTask?.resume()
            }
        }
    }
    
    //Mark: Private functions
    private func updateSearchResults(_ data: Data) {
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ImageResponseModel.self, from: data)
            imageResults = response
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            debugPrint("\(errorMessage)")
            return
        }
    }
    
//    private func save(data:Data, page:Int, fileName:String) {
//        switch page {
//        case 1:
//            saveData(data: data, toFile: fileName)
//        default:
//            appendData(data: data, toFile: fileName)
//        }
//    }
//
    private func saveData(data : Data, toFile fileName:String) {
        WriterTask.shared().writeDataToFile(data: data, fileName: fileName)
    }
    
//    private func appendData(data:Data, toFile fileName:String) {
//        WriterTask.shared().appendDataToFile(data: data, fileName: fileName)
//    }
    
    private func readData(fromFile fileName:String) -> Data?{
        let data = WriterTask.shared().readDataFromFile(fileName: fileName)
        return data
    }
    
    private func resetLocalVariables() {
        imageResults = nil
        errorMessage = ""
    }
    
}


