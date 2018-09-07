//
//  ReachabilityManager.swift
//  TestApp
//
//  Created by B0203596 on 07/09/18.
//  Copyright © 2018 Rohit. All rights reserved.
//

import Foundation

class ReachabilityManager: NSObject {
    static  let shared = ReachabilityManager()  // 2. Shared instance
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .none
    }
    private var reachabilityStatus: Reachability.Connection = .none
    private let reachability = Reachability()!
    
    func startNetworkMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .wifi:
            reachabilityStatus = .wifi
            print("Reachable via WiFi")
        case .cellular:
            reachabilityStatus = .cellular
            print("Reachable via Cellular")
        case .none:
            reachabilityStatus = .none
            print("Network not reachable")
        }
    }
    
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
}
