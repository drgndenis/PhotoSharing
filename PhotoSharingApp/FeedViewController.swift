//
//  FeedViewController.swift
//  PhotoSharingApp
//
//  Created by Denis DRAGAN on 10.06.2023.
//

import UIKit
import FirebaseFirestore
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseGetData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        
        cell.emailLabel.text = posts[indexPath.row].email
        cell.postImageView.sd_setImage(with: URL(string: posts[indexPath.row].imageURL))
        cell.commentLabel.text = posts[indexPath.row].comment
        return cell
    }
    
    func firebaseGetData() {
        let firestoreDb = Firestore.firestore()
        firestoreDb.collection("Post").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.errorMessage(message: "Error")
            } else {
                // hata yoksa veriler dbden ekrana getirilir.
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.posts.removeAll()
                    
                    for document in snapshot!.documents {
                        
                        if let email = document.get("email") as? String {
                            if let comment = document.get("comment") as? String {
                                if let imageURL = document.get("imageURL") as? String {
                                    let post = Post(email: email, comment: comment, imageURL: imageURL)
                                    self.posts.append(post)
                                }
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func errorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
}
