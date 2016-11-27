//
//  UserDetails+CoreDataProperties.swift
//  HubblerTask
//
//  Created by Arjun P A on 26/11/16.
//  Copyright © 2016 Arjun P A. All rights reserved.
//

import Foundation
import CoreData


extension UserDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserDetails> {
        return NSFetchRequest<UserDetails>(entityName: "UserDetails");
    }
    
    @NSManaged public var data: NSData?
    @NSManaged public var date: NSDate?

}
