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
    
    private  let plistExtension = ".plist"
    
    private override init() {}
    
    class func shared() -> WriterTask {
        return sharedManager
    }
    
    lazy var plistTask : ThreadSafePlistTask = {
        let plistName = "/"+"ImageSearch"+plistExtension
        let plistPath = getCacheDataDirectory().appendingFormat(plistName)
        let dataPlist = ThreadSafePlistTask(plistPath: plistPath, writeFrequency: ThreadSafePlistWriteFrequency.normal)
        return dataPlist
    }()
    
    
    private func getCacheDataDirectory() -> String {
        let path : String = ((NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)[0]) as String)
        let destPath : String = path.appending("/Data")
        if !FileManager.default.fileExists(atPath: destPath) {
            do {
                try FileManager.default.createDirectory(atPath: destPath, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                debugPrint("\(error.localizedDescription)")
            }
        }
        return destPath
    }
    
    
    private func writeData(searchResponse:[[String:Any]], key:String) {
        if searchResponse.count == 0 {
            return
        }
        plistTask.writeSync(key: key, completion: { (value) -> AnyObject? in
            return NSKeyedArchiver.archivedData(withRootObject: searchResponse) as AnyObject
        })
        
        plistTask.tryExpnesiveWrite(expnesiveWrite: true)
    }
    
    
    private func readData(key: String) -> [[String:Any]]? {
        if let tValue = plistTask.valueForKey(key: key) as? Data, let responseArray = NSKeyedUnarchiver.unarchiveObject(with: tValue) as? Array<Dictionary<String,Any>> {
            return responseArray
        }
        return nil
    }
    
    func saveDataToPlist(response:[[String:Any]], forKey key:String, shouldAppend:Bool) {
        if response.count == 0 {
            return
        }
        
        if var savedResponse = readData(key: key), shouldAppend {
            savedResponse.append(contentsOf: response)
            writeData(searchResponse: savedResponse, key: key)
        } else {
            writeData(searchResponse: response, key: key)
        }
    }
    
    func getDataForKey(key:String) -> [[String:Any]]? {
        return readData(key:key)
    }
}
