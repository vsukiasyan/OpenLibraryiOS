//
//  FirstViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet weak var tableView: UITableView!
    var searchTask: DispatchWorkItem?
    var searchController: UISearchController!
    
    var books: [doc] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        definesPresentationContext = true
        
    }
    
    
    
    func updateSearchResults(for searchController: UISearchController) {
        self.searchTask?.cancel()
        
        // Replace previous task with a new one
        let task = DispatchWorkItem { [weak self] in
            print(searchController.searchBar.text)
            // Make URL request here
            
            guard let searchKey = searchController.searchBar.text else { return }
            let url = "https://openlibrary.org/search.json?q=\(searchKey)"
            guard let searchUrl = URL(string: url) else { return }
            
            print(searchUrl)
            
            URLSession.shared.dataTask(with: searchUrl, completionHandler: { (data, response, error) in
                guard let data = data else { return }
                do {
                    let object = try JSONDecoder().decode(BookObject.self, from: data)
                    self?.books = object.docs
                    //print(self?.books)
                    print("docs count: ", object.docs.count)
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                    
                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
                
                
            }).resume()
            
        }
        self.searchTask = task
        
        // Execute task in 0.75 seconds (if not cancelled !)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.75, execute: task)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("books count: ", books.count)
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as? TableCell {
            let book = books[indexPath.row]
            cell.setUp(book)
            
            return cell
        }
        return UITableViewCell()
    }
  

}

