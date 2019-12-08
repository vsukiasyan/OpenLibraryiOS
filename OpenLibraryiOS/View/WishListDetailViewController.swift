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
    @IBOutlet weak var publisher: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var languages: UILabel!
    @IBOutlet weak var wishListBtn: UIButton!
    
    // Book object that will be used to display book info
    var book: Book = Book()
    
    // Lazy initilization of Presenter class
    lazy var presenter = Presenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUp()
    }
    
    // Set up initial view
    func setUp() {
        
        if book.cover_i != 0 {
            imageView.imageFromServerURL(urlString: "https://covers.openlibrary.org/b/id/" + "\(book.cover_i)" + "-M.jpg")
        } else {
            imageView.image = UIImage(named: "noimage")
        }
        
        self.imageView.layer.shadowColor = UIColor.black.cgColor
        self.imageView.layer.shadowOpacity = 1.0
        self.imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        self.imageView.layer.shadowRadius = 3.0
        self.imageView.layer.masksToBounds = false
        
        bookTitle.text = book.title
        bookAuthor.text = book.author_name
        yearPublished.text = "Published: \(book.first_publish_year)"
        publisher.text = "Publisher: \(book.publisher)"
        type.text = "Type: \(book.type)"
        languages.text = "Languages: \(book.language)"
        
        wishListBtn.layer.borderWidth = 1.5
        wishListBtn.layer.cornerRadius = 5.0
        wishListBtn.contentEdgeInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
        wishListBtn.addTarget(self, action: #selector(removeFromWishList), for: .touchUpInside)
    }
    
    // Remove book from WishList
    @objc func removeFromWishList() {
        presenter.remove(book: book)
        
        // Disable the button so the user doesn't try to remove it again
        wishListBtn.isEnabled = false
    }
}
