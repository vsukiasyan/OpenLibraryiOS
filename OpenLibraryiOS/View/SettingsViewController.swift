//
//  SettingsViewController.swift
//  OpenLibraryiOS
//
//  Created by Vic Sukiasyan on 12/5/19.
//  Copyright © 2019 Vic Sukiasyan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    // Segmented Control to keep track of search settings
    @IBOutlet weak var settingsControl: UISegmentedControl!
    
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up UserDefaults
        // If UserDefaults for searchSettings exists, change the index of the segmented control
        // If it doesn't, set index 0 as default
        if UserDefaults.standard.object(forKey: "searchSettings") != nil {
            settingsControl.selectedSegmentIndex = UserDefaults.standard.integer(forKey: "searchSettings")
        } else {
            UserDefaults.standard.set(0, forKey: "searchSettings")
        }
    }
    
    // Dismiss the current modal VC
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Keep track of the segmented control's state in UserDefaults
    @IBAction func indexChanged(_ sender: Any) {
        switch settingsControl.selectedSegmentIndex {
        case 0:
            userDefaults.set(0, forKey: "searchSettings")
        case 1:
            userDefaults.set(1, forKey: "searchSettings")
        case 2:
            userDefaults.set(2, forKey: "searchSettings")
        default:
            print("Search Settings ERROR!")
        }
    }
}
