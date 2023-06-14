//
//  ViewController.swift
//  PhotoSharingApp
//
//  Created by Denis DRAGAN on 9.06.2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        performSegue(withIdentifier: "toFeedVC", sender: nil)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if emailTextField.text != "" && passwordTextField.text != "" {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (authDataResult, error) in
                if error != nil {
                    self.errorMessage(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error, try again")
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        } else {
            errorMessage(titleInput: "Error", messageInput: "Enter username and password")
        }
    }
    
    func errorMessage(titleInput: String, messageInput: String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
