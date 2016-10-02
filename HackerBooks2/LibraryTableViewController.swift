//
//  LibraryTableViewController.swift
//  HackerBooks2
//
//  Created by Alejandro on 01/10/16.
//  Copyright © 2016 Alejandro. All rights reserved.
//

import UIKit
import CoreData

class LibraryTableViewController: CoreDataTableViewController {
    fileprivate var _tags: [Tag]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "HackerBooks2"
    }
}

extension LibraryTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "BookCell"
        let bookTag = self.fetchedResultsController?.object(at: indexPath) as! BookTag
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if (cell == nil) {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.text = bookTag.book!.title
        var all = [String]()
        for author in bookTag.book!.authors! {
            let a = author as! Author
            all.append(a.name!)
        }
        
        cell?.detailTextLabel?.text = all.joined(separator: ", ")
        
        return cell!
    }
}
