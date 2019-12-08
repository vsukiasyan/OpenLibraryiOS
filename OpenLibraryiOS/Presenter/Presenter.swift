//
//  Presenter.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/7/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import Foundation
import RealmSwift

class Presenter {
    
    // lazy load of Realm
    lazy var realm: Realm = {
        return try! Realm()
    }()
    
    // Base URL to start from
    let startURL = "https://openlibrary.org/search.json?"
    
    // Build the URL with the searchKey provided
    func buildURL(searchKey: String) -> URL {
        var setting = ""
        switch UserDefaults.standard.integer(forKey: "searchSettings") {
        case 0:
            setting = "q="
        case 1:
            setting = "title="
        case 2:
            setting = "author="
        default:
            setting = "q="
        }
        
        let url = "\(startURL)\(setting)\(searchKey.replacingOccurrences(of: " ", with: "+"))"
        guard let searchURL = URL(string: url) else { return URL(string: "")! }
        
        return searchURL
    }
    
    // Send a request to the API and pass in the returned object
    func searchAPI(searchURL: URL, completion: @escaping ([doc]) -> Void) {
        URLSession.shared.dataTask(with: searchURL, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let object = try JSONDecoder().decode(BookObject.self, from: data)
                completion(object.docs)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }).resume()
    }
    
    // Add book to WishList
    func append(book: doc) {
        let realmBook = Book()
        
        if let title = book.title, let author = book.author_name?.first, let publishYear = book.first_publish_year,
           let editionCount = book.edition_count, let publisher = book.publisher?.first, let type = book.type {
            // Assign values to new Book
            realmBook.title = title
            realmBook.author_name = author
            realmBook.first_publish_year = publishYear
            realmBook.edition_count = editionCount
            realmBook.publisher = publisher
            realmBook.type = type
        }
        
        if let cover = book.cover_i {
            realmBook.cover_i = cover
        }
        
        if let languages = book.language {
            realmBook.language = languages.joined(separator: ", ")
        }
        
        // Write book to Realm DB
        try! realm.write {
            realm.add(realmBook)
        }
    }
    
    // Remove book from WishList
    func remove(book: Book) {
        try! realm.write {
            realm.delete(book)
        }
    }
    
    // Get all Book objects if any
    func getObjects() -> Results<Book> {
        return realm.objects(Book.self)
    }
    
    // Check if Realm DB is empty
    func isRealmEmpty() -> Bool {
        return realm.isEmpty
    }
}

