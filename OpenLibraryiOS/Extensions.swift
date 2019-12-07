//
//  Extensions.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/6/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func emptyTableViewMessage(message: String, tableView: UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: tableView.bounds.size.width, height: tableView.bounds.size.height))
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
