//
//  Glucose+CoreDataClass.swift
//  CoreDataTest
//
//  Created by Pedro Ésli Vieira do Nascimento on 14/10/21.
//
//

import Foundation
import CoreData
import UIKit

@objc(Glucose)
public class Glucose: NSManagedObject {
    func getUIImage() -> UIImage{
        guard let imageData = self.imageData, let image = UIImage(data: imageData) else{
            return UIImage(systemName: "photo")!
        }
        return image
    }
    
    func getFormatedTime() -> String{
        let dateFormater = DateFormatter()
        dateFormater.timeStyle = .short
        return dateFormater.string(from: self.timeRegistered!)
    }
}
