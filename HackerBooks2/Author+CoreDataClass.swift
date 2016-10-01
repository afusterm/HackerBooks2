//
//  Author+CoreDataClass.swift
//  HackerBooks2
//
//  Created by Alejandro on 21/09/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import Foundation
import CoreData


public class Author: NSManagedObject {
    static let entityName = "Author"
    
    convenience init(name: String, inContext context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Author.entityName, in: context)!
        self.init(entity: entity, insertInto: context)
        self.name = name
    }
}
