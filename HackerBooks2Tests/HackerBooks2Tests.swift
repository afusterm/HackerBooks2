//
//  HackerBooks2Tests.swift
//  HackerBooks2Tests
//
//  Created by Alejandro on 20/09/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import XCTest
import CoreData

@testable import HackerBooks2

class HackerBooks2Tests: XCTestCase {
    static func getJSONURL() -> URL {
        guard let jsonURL = Bundle.main.url(forResource: "books_readable", withExtension: "json") else {
            fatalError("Unable to read JSON file")
        }
        
        return jsonURL
    }
    
    var model = CoreDataStack(modelName: "Model")!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReadFromJSONFile() {
        let jsonURL = HackerBooks2Tests.getJSONURL()
        
        let dict = try? read(fromJSON: jsonURL)
        if let books = dict {
            XCTAssertEqual(books.count, 30)
            
            
        } else {
            XCTAssert(false, "Error while reading json file")
        }
    }
}
