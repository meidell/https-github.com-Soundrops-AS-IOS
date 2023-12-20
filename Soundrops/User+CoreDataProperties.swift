//
//  User+CoreDataProperties.swift
//  Soundrops
//
//  Created by Jan Erik Meidell on 11.02.19.
//  Copyright © 2019 Jan Erik Meidell. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: String?
    @NSManaged public var audio: Int16
    @NSManaged public var country: String?
    @NSManaged public var gender: String?
    @NSManaged public var id: String?
    @NSManaged public var myaccept: String?
    @NSManaged public var myID: String?
    @NSManaged public var mymail: String?
    @NSManaged public var name: String?
    @NSManaged public var organisation: String?

}
