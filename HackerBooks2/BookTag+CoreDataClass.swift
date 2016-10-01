//
//  BookTag+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alejandro on 21/09/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import CoreData


public class BookTag: NSManagedObject {
    static let entityName = "BookTag"
    
    convenience init(book: Book, tag: Tag, inContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: BookTag.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.book = book
        self.tag = tag
    }
}
