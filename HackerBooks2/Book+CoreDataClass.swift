//
//  Book+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alejandro on 21/09/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import CoreData


public class Book: NSManagedObject {
    static let entityName = "Book"
    
    convenience init(title: String, authors: NSSet, inContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Book.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.title = title
        self.authors = authors
    }
}
