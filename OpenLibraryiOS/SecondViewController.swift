//
//  SecondViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    var books: Results<Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        books = realm.objects(Book.self)
        tableView.reloadData()
        if realm.isEmpty {
            EmptyMessage(message: "Looks like your Wish List is empty.", tableView: tableView)
        } else {
            tableView.backgroundView = nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell") as? WishListCell {
            
            cell.setUp((books?[indexPath.row])!)
            cell.wishListTitle.text = books[indexPath.row].title
            cell.wishListAuthor.text = books[indexPath.row].author_name
            cell.wishListPublish.text = "First published: \(books[indexPath.row].first_publish_year)"
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Delete this", indexPath.row)
            
            deleteBookAt(index: indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    func deleteBookAt(index: Int) {
        try! realm.write {
            realm.delete(self.books[index])
        }
        if realm.isEmpty {
            EmptyMessage(message: "Looks like your Wish List is empty.", tableView: tableView)
        }
    }

    func EmptyMessage(message: String, tableView: UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = UIColor.blue
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        
        tableView.backgroundView = messageLabel
        tableView.separatorStyle = .none
    }
}

