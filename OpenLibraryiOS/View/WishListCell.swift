//
//  WishListCell.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class WishListCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var wishListTitle: UILabel!
    @IBOutlet weak var wishListAuthor: UILabel!
    @IBOutlet weak var wishListPublish: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Basic UI set up for cell
    func setUp(_ book: Book) {
        if book.cover_i != 0 {
            img.imageFromServerURL(urlString: "https://covers.openlibrary.org/b/id/" + "\(book.cover_i)" + "-M.jpg")
        } else {
            self.img.image = UIImage(named: "noimage")
        }
        
        wishListTitle.text = book.title
        wishListAuthor.text = book.author_name
        wishListPublish.text = "First published: \(book.first_publish_year)"
    }
}
