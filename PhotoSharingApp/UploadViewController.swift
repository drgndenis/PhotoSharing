//
//  UploadViewController.swift
//  PhotoSharingApp
//
//  Created by Denis DRAGAN on 10.06.2023.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var commentTextField: UITextField!
    var imageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func selectImage() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true)
    }
    
    // Galeriye gidip image secme
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadPressed(_ sender: Any) {
        // Fotografin firebase uzerine kaydedilmesi
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            let uuid = UUID().uuidString

            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { storageMetadata, error in
                if error != nil {
                    self.errorMessage(message: error?.localizedDescription ?? "Something went wrong!")
                } else {
                    imageReference.downloadURL { url, error in
                        if error == nil {
                            self.imageURL = url?.absoluteString
                            self.addInDatabase()
                        }
                    }
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
    
    func addInDatabase() {
        let firebaseDb = Firestore.firestore()
        
        // Datababase'e eklenecek dokumanlari, kullanicinin girdigi verilerle ekleme
        let firebasePost: [String: Any] = [
            "imageURL": imageURL ?? self.errorMessage(message: "Failed to fetch imageURL"),
            "comment": self.commentTextField.text ?? self.errorMessage(message: "Failed to fetch comment"),
            "email": Auth.auth().currentUser?.email ?? self.errorMessage(message: "Failed to fetch email"),
            "date": FieldValue.serverTimestamp()
        ]
        // Database koleksiyon olusturma ve dokumanları ekleme
        firebaseDb.collection("Post").addDocument(data: firebasePost) { error in
            if error != nil {
                self.errorMessage(message: error?.localizedDescription ?? "Something went wrong, try again.")
            } else {
                // veriler basarili bir sekilde yuklenirse bizi Feed ekranina yollayip, imageView'ı ve commentTextField'ı eski haline getirecek
                self.imageView.image = UIImage(named: "select")
                self.commentTextField.text = nil
                self.tabBarController?.selectedIndex = 0
            }
        }
    }
}
