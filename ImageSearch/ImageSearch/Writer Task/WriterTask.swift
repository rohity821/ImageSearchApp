//
//  WriterTask.swift
//  TestApp
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation


class WriterTask : NSObject {
    private static var sharedManager: WriterTask = WriterTask()
    
    private override init() {}
    
    class func shared() -> WriterTask {
        return sharedManager
    }
    
    func writeDataToFile(data:Data, fileName:String) {
        let filePath = "\(fileName).txt"
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filePath)
            //writing
            do {
                try data.write(to: fileURL, options: .atomic)
            }
            catch {
                debugPrint("data could not be saved")
            }
        }
    }
    
    func readDataFromFile(fileName:String) -> Data? {
        let filePath = "\(fileName).txt"
        if let dir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(filePath)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                //reading
                do {
                    let data = try Data(contentsOf: fileURL)
                    return data
                }
                catch {
                    debugPrint("data could not be read")
                }
            }
        }
        return nil
    }
    
}
