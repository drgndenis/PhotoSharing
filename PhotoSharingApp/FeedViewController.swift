//
//  FeedViewController.swift
//  PhotoSharingApp
//
//  Created by Denis DRAGAN on 10.06.2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    
    var emails = [String]()
    var comments = [String]()
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseGetData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.emailLabel.text = emails[indexPath.row]
        cell.postImageView.sd_setImage(with: URL(string: self.images[indexPath.row]))
        cell.commentLabel?.text = comments[indexPath.row]
        return cell
    }
    
    func firebaseGetData() {
        let firestoreDb = Firestore.firestore()
        firestoreDb.collection("Post").addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            } else {
                // hata yoksa verilerin dbden getirilmesi
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents {
                        
                        if let email = document.get("email") as? String {
                            self.emails.append(email)
                        }
                        
                        if let comment = document.get("comment") as? String {
                            self.comments.append(comment)
                        }
                        
                        if let imageURL = document.get("imageURL") as? String {
                            self.images.append(imageURL)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
}
