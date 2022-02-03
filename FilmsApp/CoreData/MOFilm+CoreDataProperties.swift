//
//  MOFilm+CoreDataProperties.swift
//  FilmsApp
//
//  Created by Максим Моргун on 02.02.2022.
//
//

import Foundation
import CoreData


extension MOFilm {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MOFilm> {
        return NSFetchRequest<MOFilm>(entityName: "MOFilm")
    }

    @NSManaged public var filmTitle: String?
    @NSManaged public var filmImage: Data?

}

extension MOFilm : Identifiable {

}
