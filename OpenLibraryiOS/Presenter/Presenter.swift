//
//  Presenter.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/7/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import Foundation

class Presenter {
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
        print("SearchURL: ", searchURL)
        
        return searchURL
    }
    
    // Send a request to the API and pass in the returned object
    func searchAPI(searchURL: URL, completion: @escaping ([doc]) -> Void) {
        URLSession.shared.dataTask(with: searchURL, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let object = try JSONDecoder().decode(BookObject.self, from: data)
                completion(object.docs)
                print("docs count: ", object.docs.count)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }).resume()
    }
}

