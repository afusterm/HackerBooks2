//
//  AppDelegate.swift
//  HackerBooks2
//
//  Created by Alejandro on 20/09/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit
import CoreData

let urlHackerBooks = "https://t.co/K9ziV0z3SJ"
let localBooksFilename = "books.json"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var model = CoreDataStack(modelName: "Model")!
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if isFirstTime() {
            do {
                try downloadJSONFrom(string: urlHackerBooks, asLocalName: localBooksFilename, completion: { (jsonURL) in
                    let dict = try? read(fromJSON: jsonURL)
                    if let booksArray = dict {
                        self.importBooks(fromJSONArray: booksArray)
                    }
                    
                    let fc = self.createResultsController()
                    
                    DispatchQueue.main.async {
                        let libraryTV = LibraryTableViewController(fetchedResultsController: fc, style: .plain)
                        let nav = UINavigationController(rootViewController: libraryTV)
                        
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = nav
                        self.window?.makeKeyAndVisible()
                    }
                })
            } catch let err as HackerBooksError {
                fatalError("Error on downloadJSON: " + err.description)
            } catch {
                fatalError("Error on downloadJSON")
            }
        
            setAppLaunched()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // MARK: - Utils
    
    /**
     *  Indicate wether it is the first time the application is launched.
     */
    private func isFirstTime() -> Bool {
        let userDef = UserDefaults.standard
        let firstTime = !userDef.bool(forKey: "appLaunched")
        
        return firstTime
    }
    
    /**
     *  Sets that the application has already been launched.
     */
    private func setAppLaunched() {
        let userDef = UserDefaults.standard
        userDef.set(true, forKey: "appLaunched")
    }
    
    
    private func importBooks(fromJSONArray json: JSONArray) {
        do {
            try self.model.dropAllData()
        } catch let error {
            print("Unable to drop data: " + error.localizedDescription)
        }
        
        for dict in json {
            book(withJSONDictionary: dict)
        }
        
        self.model.save()
    }
    
    private func book(withJSONDictionary dict: JSONDictionary) {
        let authorsArray = arrayFrom(string: dict["authors"] as! String)
        let authors = createAuthorsObjectsFrom(array: authorsArray)
        let book = Book(title: dict["title"] as! String, authors: authors, inContext: model.context)
        let tagsArray = arrayFrom(string: dict["tags"] as! String)
        createBookTags(book: book, tags: tagsArray)
    }
    
    private func createAuthorsObjectsFrom(array: [String]) -> NSSet {
        let authors = NSMutableSet()
        
        for author in array {
            let a = Author(name: author, inContext: model.context)
            authors.add(a)
        }
        
        return authors
    }
    
    private func createBookTags(book: Book, tags: [String]) {
        for tag in tags {
            let t = Tag(name: tag, inContext: model.context)
            let _ = BookTag(book: book, tag: t, inContext: model.context)
        }
    }
    
    private func createResultsController() -> NSFetchedResultsController<NSFetchRequestResult> {
        let fr = NSFetchRequest<BookTag>(entityName: BookTag.entityName)
        fr.fetchBatchSize = 50
        fr.sortDescriptors = [NSSortDescriptor(key: "tag.name", ascending: true),
                              NSSortDescriptor(key: "book.title", ascending: true)]
        
        let fc = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: self.model.context,
                                            sectionNameKeyPath: "tag.name", cacheName: nil)
        
        return fc as! NSFetchedResultsController<NSFetchRequestResult>
    }
}

/**
   Downloads the JSON file with all books.
 
   - Parameter string: URL's string where is the JSON file with the books.
 
   - Parameter lName: File local name where the JSON file will be saved.
 */
func downloadJSONFrom(string str: String, asLocalName lName: String,
                      completion: @escaping (_ json: URL) -> ()) throws {
    var urlDst = Bundle.main.resourceURL!
    
    guard let urlSrc = URL(string: str) else {
        throw HackerBooksError.resourcePointedByURLNotReachable
    }
    
    let task = URLSession.shared.dataTask(with: urlSrc, completionHandler: { (data, response, error) -> Void in
        if let urlContent = data {
            urlDst.appendPathComponent(lName)
            // TODO: don't let me to throw an exception from here
            try? urlContent.write(to: urlDst)
            completion(urlDst)
        }
    })
    
    task.resume()
}
