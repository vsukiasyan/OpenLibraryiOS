//
//  Book.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import Foundation
import RealmSwift

struct BookObject: Decodable{
    let start: Int?
    let num_found: Int?
    let docs: [doc]
}

//struct Books: Decodable{
//    let object: [BookObject]
//}

struct doc: Decodable{
    let title: String?
    let subtitle: String?
    let author_name: [String]?
    let first_publish_year: Int?
    let edition_count: Int?
    let cover_i: Int?
    let publisher: [String]?
    let author_alternative_name: [String]?
    let ia: [String]?
}

class Book: Object {
    @objc dynamic var title = ""
    @objc dynamic var author_name = ""
    @objc dynamic var first_publish_year = 0
}

