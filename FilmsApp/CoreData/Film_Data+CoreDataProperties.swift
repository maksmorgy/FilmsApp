//
//  Film_Data+CoreDataProperties.swift
//  FilmsApp
//
//  Created by Максим Моргун on 30.01.2022.
//
//

import Foundation
import CoreData


extension Film_Data {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Film_Data> {
        return NSFetchRequest<Film_Data>(entityName: "Film_Data")
    }

    @NSManaged public var filmImage: Data?
    @NSManaged public var filmTitle: String?

}

extension Film_Data : Identifiable {

}
