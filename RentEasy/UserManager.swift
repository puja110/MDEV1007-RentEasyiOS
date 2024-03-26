//
//  UserManager.swift
//  RentEasy
//
//  Created by Oladipupo Olasile on 2024-03-23.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage

//MARK: - USER STRUCT
struct User {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var profileImageUrl: String?
}

//MARK: - USER MANAGER
class UserManager {
    private let db = Firestore.firestore()
    static let shared = UserManager()
    var currentUser: User?
    var currentUserId: String?
    private init() {}

    //MARK: - USER DETAILS FOR Dependency Injection
    func fetchUserDetails(userId: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                print("User data not found.")
                completion(false)
                return
            }

            self.currentUser = User(id: userId,
                                    firstName: data["firstName"] as? String ?? "",
                                    lastName: data["lastName"] as? String ?? "",
                                    email: data["email"] as? String ?? "", phoneNumber: data["phoneNumber"] as? String ?? "", profileImageUrl: data["profileImageUrl"] as? String ?? "")
//            print("Fetched User Details-> \(self.currentUser)")
            completion(true)
        }
    }
    
    func loginUser(userId: String) {
           currentUserId = userId
       }

       func logoutUser() {
           currentUserId = nil
       }
    
    
    //MARK: -  USER DETAILS UPDATE FIRESTORE
        func updateUserDetails(firstName: String, lastName: String, email: String, phoneNumber: String, completion: @escaping (Bool, Error?) -> Void) {
            guard let userID = currentUserId else {
                completion(false, nil)
                return
            }

            let userDetails = [
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "phoneNumber": phoneNumber
            ]

            db.collection("users").document(userID).updateData(userDetails) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    self.currentUser?.firstName = firstName
                    self.currentUser?.lastName = lastName
                    self.currentUser?.email = email
                    self.currentUser?.phoneNumber = phoneNumber

                    completion(true, nil)
                }
            }
        }
    
    //MARK: - USER Profile picture
    func updateProfileImage(userId: String, image: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(false, nil)
            return
        }
        let storageRef = Storage.storage().reference().child("profileImages/\(userId).jpg")
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard let _ = metadata else {
                completion(false, error)
                return
            }
            storageRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(false, error)
                    return
                }
                self.db.collection("users").document(userId).updateData(["profileImageUrl": downloadURL.absoluteString]) { error in
                    if let error = error {
                        completion(false, error)
                    } else {
                        if self.currentUser?.id == userId {
                            self.currentUser?.profileImageUrl = downloadURL.absoluteString
                        }
                        completion(true, nil)
                    }
                }
            }
        }
    }
}
