//
//  SettingsViewController.swift
//  PhotoSharingApp
//
//  Created by Denis DRAGAN on 10.06.2023.
//

import UIKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        performSegue(withIdentifier: "toViewController", sender: nil)
    }
}
