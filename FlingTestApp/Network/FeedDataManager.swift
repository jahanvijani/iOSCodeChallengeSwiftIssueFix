//
//  FeedDataManager.swift
//  FlingTestApp
//
//  Created by Jahanvi Vyas on 10/04/2016.
//  Copyright © 2016 Jahanvi Vyas. All rights reserved.
//

import Foundation

class FeedDataManager: NSObject {
    
    static let sharedInstance = FeedDataManager()
    
    var feeds: NSMutableArray = []
    
    func getFeedDataWithCompletion(completionHandler:((NSError?)) -> Void)
    {
            if(RestAPIManager.isConnectedToNetwork())
            {
                //Call API for feed data
                let url:NSURL = NSURL(string: kBaseURL)!
                RestAPIManager.requestDataWithURL(url,completionHandler: { (data, error) -> Void in
                    if error == nil {
                        self.parseJSONData(data!)
                        completionHandler(error)
                    }
                    else
                    {
                        completionHandler(error)
                    }
                })
            }
            else
            {
                //Get data from Core Data in offline mode
                let coreDataManager = CoreDataManager()
                feeds = NSMutableArray(array: coreDataManager.getFeed()!)
                
                completionHandler(NSError(domain: "", code: kNoInternetErrorCode, userInfo: nil))
            }
        
    }
    
    func downloadImageWithCompletion(imageID:NSNumber, completionHandler:((Bool)) -> Void)
    {
        if(RestAPIManager.isConnectedToNetwork())
        {
            //Generate URL to get image
            let url:NSURL = NSURL(string: kBaseURL+kGetPhotosEndPoint+String(imageID))!
            
            RestAPIManager.requestDataWithURL(url,completionHandler: { (data, error) -> Void in
                if error == nil {
                    
                    let coreDataManager = CoreDataManager()
                    coreDataManager.updateFeed(imageID,imageData: data!)
                    completionHandler(true)
                }
                else
                {
                    completionHandler(false)
                }
            })
        }
        else
        {
            completionHandler(false)
        }
    }
    
    func parseJSONData(data:NSData)
    {
        //Delete existing data from Entity
        let coreDataManagerClear = CoreDataManager()
        coreDataManagerClear.clearFeedData()
        var feedsArray: NSArray!
        do {
            feedsArray = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSArray
            
            //Save all feeds in Feed entity
            for feed in feedsArray {
                let coreDataManager = CoreDataManager()
                let feed: Feed = coreDataManager.saveFeed(feed as! NSDictionary)
                self.feeds.addObject(feed)
            }
            
        } catch {
            print(error)
        }
    }

}