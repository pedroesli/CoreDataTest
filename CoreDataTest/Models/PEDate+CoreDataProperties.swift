//
//  PEDate+CoreDataProperties.swift
//  CoreDataTest
//
//  Created by Pedro Ésli Vieira do Nascimento on 14/10/21.
//
//

import Foundation
import CoreData


extension PEDate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PEDate> {
        return NSFetchRequest<PEDate>(entityName: "PEDate")
    }

    @NSManaged public var day: Int64
    @NSManaged public var month: Int64
    @NSManaged public var year: Int64
    @NSManaged public var glucoseLevels: NSOrderedSet?

}

// MARK: Generated accessors for glucoseLevels
extension PEDate {

    @objc(insertObject:inGlucoseLevelsAtIndex:)
    @NSManaged public func insertIntoGlucoseLevels(_ value: Glucose, at idx: Int)

    @objc(removeObjectFromGlucoseLevelsAtIndex:)
    @NSManaged public func removeFromGlucoseLevels(at idx: Int)

    @objc(insertGlucoseLevels:atIndexes:)
    @NSManaged public func insertIntoGlucoseLevels(_ values: [Glucose], at indexes: NSIndexSet)

    @objc(removeGlucoseLevelsAtIndexes:)
    @NSManaged public func removeFromGlucoseLevels(at indexes: NSIndexSet)

    @objc(replaceObjectInGlucoseLevelsAtIndex:withObject:)
    @NSManaged public func replaceGlucoseLevels(at idx: Int, with value: Glucose)

    @objc(replaceGlucoseLevelsAtIndexes:withGlucoseLevels:)
    @NSManaged public func replaceGlucoseLevels(at indexes: NSIndexSet, with values: [Glucose])

    @objc(addGlucoseLevelsObject:)
    @NSManaged public func addToGlucoseLevels(_ value: Glucose)

    @objc(removeGlucoseLevelsObject:)
    @NSManaged public func removeFromGlucoseLevels(_ value: Glucose)

    @objc(addGlucoseLevels:)
    @NSManaged public func addToGlucoseLevels(_ values: NSOrderedSet)

    @objc(removeGlucoseLevels:)
    @NSManaged public func removeFromGlucoseLevels(_ values: NSOrderedSet)

}

extension PEDate : Identifiable {

}
