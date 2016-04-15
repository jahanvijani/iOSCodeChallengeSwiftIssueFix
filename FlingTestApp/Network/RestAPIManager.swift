//
//  RestAPIManager.swift
//  FlingTestApp
//
//  Created by Jahanvi Vyas on 10/04/2016.
//  Copyright © 2016 Jahanvi Vyas. All rights reserved.
//

import Foundation

class RestAPIManager: NSObject {
    
    class func requestDataWithURL(url: NSURL, completionHandler:((NSData?,NSError?)) -> Void)
    {
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            if error == nil {
                //Successful
                //let urlContent = NSString(data: data!, encoding: NSASCIIStringEncoding) as NSString!
                //print(urlContent)
            }
            completionHandler(data,error)
        })
        task.resume()
    }
    
    class func isConnectedToNetwork() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
    
}