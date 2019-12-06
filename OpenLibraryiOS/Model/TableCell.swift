//
//  TableCell.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    @IBOutlet weak var bookImg: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var publishedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(_ book: doc) {
        title.text = book.title
        author.text = book.author_name?.first
        
        guard let editions = book.edition_count else { return }
        
        var bookEditions = ""
        if editions > 1 {
            bookEditions = "\(editions) editions"
        } else {
            bookEditions = "1 edition"
        }
        
        if let pubDate = book.first_publish_year {
            publishedDate.text = "Published: \(pubDate) - \(bookEditions)"
        }
        
      
        
        if let cover = book.cover_i {
            getImage(cover_i: cover)
        } else {
            self.bookImg.image = UIImage(named: "noimage")
        }
        
    }
    
    func getImage(cover_i: Int){
        let url = "https://covers.openlibrary.org/b/id/" + "\(cover_i)" + "-M.jpg"
        
        if let imageURL = URL(string: url){
            
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        self.bookImg.image = image
                    }
                }
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
