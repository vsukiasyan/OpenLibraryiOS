//
//  Book.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import Foundation
import RealmSwift

// Book object for Realm
class Book: Object {
    @objc dynamic var title = ""
    @objc dynamic var author_name = ""
    @objc dynamic var first_publish_year = 0
    @objc dynamic var edition_count = 0
    @objc dynamic var cover_i = 0
    @objc dynamic var publisher = ""
    @objc dynamic var type = ""
    @objc dynamic var language = ""
}

// Book object for JSON initilization
struct BookObject: Decodable {
    let start: Int?
    let num_found: Int?
    let docs: [doc]
}

// doc object for array of books in JSON initialization
struct doc: Decodable {
    let title: String?
    let author_name: [String]?
    let first_publish_year: Int?
    let edition_count: Int?
    let cover_i: Int?
    let publisher: [String]?
    let type: String?
    let language: [String]?
}



