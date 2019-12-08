//
//  Presenter.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/7/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import Foundation

class Presenter {
    let startURL = "https://openlibrary.org/search.json?"
    
    func buildURL(searchKey: String) -> URL {
        var setting = ""
        if UserDefaults.standard.integer(forKey: "searchSettings") == 0 {
            setting = "q="
        } else if UserDefaults.standard.integer(forKey: "searchSettings") == 1 {
            setting = "title="
        } else if UserDefaults.standard.integer(forKey: "searchSettings") == 2 {
            setting = "author="
        }
        
        let url = "\(startURL)\(setting)\(searchKey.replacingOccurrences(of: " ", with: "+"))"
        guard let searchURL = URL(string: url) else { return URL(string: "")! }
        print("SearchURL: ", searchURL)
        
        return searchURL
    }
    
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

