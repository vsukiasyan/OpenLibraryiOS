//
//  WishListDetailViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/6/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit
import RealmSwift

class WishListDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var bookAuthor: UILabel!
    @IBOutlet weak var yearPublished: UILabel!
    @IBOutlet weak var wishListBtn: UIButton!
    
    var book: Book = Book()
    
    lazy var realm: Realm = {
        return try! Realm()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    func setUp() {
        imageView.imageFromServerURL(urlString: "https://covers.openlibrary.org/b/id/" + "\(book.cover_i)" + "-M.jpg")
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOpacity = 1.0
        self.imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.imageView.layer.shadowRadius = 3.0
        self.imageView.layer.masksToBounds = false
        
        bookTitle.text = book.title
        bookAuthor.text = book.author_name
        yearPublished.text = "Published: \(book.first_publish_year)"
        
        wishListBtn.layer.borderWidth = 1.5
        wishListBtn.layer.cornerRadius = 5.0
        wishListBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        wishListBtn.addTarget(self, action: #selector(removeFromWishList), for: .touchUpInside)
    }
    
    
    @objc func removeFromWishList() {
        try! realm.write {
            realm.delete(book)
        }
    }
}
