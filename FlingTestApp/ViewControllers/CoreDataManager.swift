//
//  CoreDataManager.swift
//  FlingTestApp
//
//  Created by Jahanvi Vyas on 10/04/2016.
//  Copyright © 2016 Jahanvi Vyas. All rights reserved.
//

import UIKit
import CoreData

struct feedDictionaryKeys {
    
    var feedID = "ID"
    var userID = "UserID"
    var photoTitle = "Title"
    var userName = "UserName"
    var photoID = "ImageID"
}

class CoreDataManager: NSObject {
    
    func saveFeed(feedData:NSDictionary) -> Feed {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("Feed",
                                                        inManagedObjectContext:managedContext)
        
        let feed = Feed(entity: entity!,
                            insertIntoManagedObjectContext: managedContext)
        
        feed.feedID = feedData["ID"] as? NSNumber
        feed.userID = feedData["UserID"] as? NSNumber
        feed.photoTitle = feedData["Title"] as? String
        feed.userName = feedData["UserName"] as? String
        feed.photoID = feedData["ImageID"] as? NSNumber
        
        //Create different ManagedObject for Background save
        let childManagedContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childManagedContext.parentContext = managedContext
        
        //Save data
        do {
            try childManagedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        return feed
    }
    
    func updateFeed(imageID:NSNumber,imageData:NSData) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        fetchRequest.predicate = NSPredicate(format: "photoID = %@", imageID)
        
        do {
            let fetchedEntities = try managedContext.executeFetchRequest(fetchRequest) as! [Feed]
            fetchedEntities.first?.photoImage = imageData
        } catch {
            // Do something in response to error condition
        }
        
        //Create different ManagedObject for Background save
        let childManagedContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        childManagedContext.parentContext = managedContext
        
        //Update data
        do {
            try childManagedContext.save()
        } catch {
            // Do something in response to error condition
        }
    }
    
    func getFeed() -> NSArray?{
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        
        do {
            let fetchedFeeds = try managedContext.executeFetchRequest(fetchRequest) as! [Feed]
            return fetchedFeeds
            
        } catch {
            // Do something in response to error condition
        }
        
        return nil
    }
    
    func clearFeedData() {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        let persistentStoreCoordinator = appDelegate.persistentStoreCoordinator
        
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try persistentStoreCoordinator.executeRequest(deleteRequest, withContext: managedContext)
        } catch let error as NSError {
            debugPrint(error)
        }
    }

}