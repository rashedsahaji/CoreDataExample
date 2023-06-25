//
//  Entity+CoreDataProperties.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 25/06/23.
//
//

import Foundation
import CoreData


extension Entity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var id: String?
    @NSManaged public var author: String?
    @NSManaged public var downloadURL: String?

}

extension Entity : Identifiable {

}
