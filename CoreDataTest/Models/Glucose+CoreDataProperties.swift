//
//  Glucose+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Pedro Ésli Vieira do Nascimento on 14/10/21.
//
//

import Foundation
import CoreData


extension Glucose {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Glucose> {
        return NSFetchRequest<Glucose>(entityName: "Glucose")
    }

    @NSManaged public var imageData: Data?
    @NSManaged public var level: Int64
    @NSManaged public var timeRegistered: Date?
    @NSManaged public var peDate: PEDate?

}

extension Glucose : Identifiable {

}
