//
//  SettingsViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingsControl: UISegmentedControl!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up UserDefaults
        if UserDefaults.standard.object(forKey: "searchSettings") != nil {
            print("UserDefaults: ", UserDefaults.standard.integer(forKey: "searchSettings"))
            settingsControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "searchSettings")
        } else {
            UserDefaults.standard.set(0, forKey: "searchSettings")
        }
     
        
    }
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func indexChanged(_ sender: Any) {
        switch settingsControl.selectedSegmentIndex {
        case 0:
            print("You picked Relevance")
            userDefaults.set(0, forKey: "searchSettings")
        case 1:
            print("You picked Title")
            userDefaults.set(1, forKey: "searchSettings")
        case 2:
            print("You picked Author")
            userDefaults.set(2, forKey: "searchSettings")
        default:
            print("ERROR")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
