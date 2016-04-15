//
//  Feed.swift
//  FlingTestApp
//
//  Created by Jahanvi Vyas on 10/04/2016.
//  Copyright © 2016 Jahanvi Vyas. All rights reserved.
//

import Foundation
import CoreData


class Feed: NSManagedObject {

    @NSManaged var feedID: NSNumber?
    @NSManaged var userID: NSNumber?
    @NSManaged var photoTitle: String?
    @NSManaged var userName: String?
    @NSManaged var photoID: NSNumber?
    @NSManaged var photoImage: NSData?
}
