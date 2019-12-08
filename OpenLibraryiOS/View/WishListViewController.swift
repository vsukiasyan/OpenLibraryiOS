//
//  WishListViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit
import RealmSwift

class WishListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    // Lazy initilization of Presenter class
    lazy var presenter = Presenter()
    
    // Array of books returned from Realm
    var books: Results<Book>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Table view setup
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
    }
    
    // Load books array from Realm when view appears or show empty message
    override func viewWillAppear(_ animated: Bool) {
        books = presenter.getObjects()
        
        tableView.reloadData()
        
        if presenter.isRealmEmpty() {
            tableView.emptyTableViewMessage(message: "Looks like your Wish List is empty.", tableView: tableView)
        } else {
            tableView.backgroundView = nil
        }
    }
    
    // Basic table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "WishListCell") as? WishListCell,
            let book = books?[indexPath.row] {
            
            cell.setUp(book)
            
            return cell
        }
        return UITableViewCell()
    }
    
    // Slide to delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteBookAt(index: indexPath.row)
            tableView.reloadData()
        }
    }
    
    // Delete selected book from an index and check if list is empty to display a message
    func deleteBookAt(index: Int) {
        presenter.remove(book: books[index])
        
        if presenter.isRealmEmpty() {
            tableView.emptyTableViewMessage(message: "Looks like your Wish List is empty.", tableView: tableView)
        }
    }
    
    // Prepare for the segue and pass in any needed data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = tableView.indexPathForSelectedRow
        
        if segue.identifier == "WishListVC" {
            let wishListVC = segue.destination as! WishListDetailViewController
            let book = books![(indexPath?.row)!]
            wishListVC.book = book
        }
        
    }
}

