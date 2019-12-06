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
    
    func setUp(_ book: Book) {
        if book.cover_i != 0 {
            getImage(cover_i: book.cover_i)
        } else {
            self.img.image = UIImage(named: "noimage")
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
                        self.img.image = image
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
