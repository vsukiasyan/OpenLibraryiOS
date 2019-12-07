//
//  BookDetailViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit
import RealmSwift

class BookDetailViewController: UIViewController {
    var book: doc?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var publishedLbl: UILabel!
    
    @IBOutlet weak var wishlistBtn: UIButton!
    
    lazy var realm:Realm = {
        return try! Realm()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    // Set up the image and text views
    func setUp() {
        if let cover = book?.cover_i {
            imageView.imageFromServerURL(urlString: "https://covers.openlibrary.org/b/id/" + "\(cover)" + "-M.jpg")
            //imageView.image = UIImage(url: URL(string: "https://covers.openlibrary.org/b/id/" + "\(cover)" + "-M.jpg"))
            self.imageView.layer.shadowColor = UIColor.black.cgColor
            self.imageView.layer.shadowOpacity = 1.0
            self.imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
            self.imageView.layer.shadowRadius = 3.0
            self.imageView.layer.masksToBounds = false
        } else {
            self.imageView.image = UIImage(named: "noimage")
        }
        
        if let bookTitle = book?.title {
            titleLbl.text = bookTitle
        }
        
        if let bookAuthor = book?.author_name?.first {
            authorLbl.text = bookAuthor
        }
       
        var bookEditions = ""
        guard let editions = book?.edition_count else { return }
        if editions > 1 {
            bookEditions = "\(editions) editions"
        } else {
            bookEditions = "1 edition"
        }
        
        if let pubDate = book?.first_publish_year {
            publishedLbl.text = "Published: \(pubDate) - \(bookEditions)"
        }
        
        wishlistBtn.layer.borderWidth = 1.5
        wishlistBtn.layer.cornerRadius = 5.0
        wishlistBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        wishlistBtn.addTarget(self, action: #selector(addToWishlist), for: .touchUpInside)
    }
    
    // Add current book to the Wish List / Realm DB
    @objc func addToWishlist() {
        let realmBook = Book()
        realmBook.title = (book?.title)!
        realmBook.author_name = (book?.author_name!.first)!
        realmBook.first_publish_year = (book?.first_publish_year)!
        realmBook.cover_i = (book?.cover_i)!

        try! realm.write {
            realm.add(realmBook)
        }
    }
}
