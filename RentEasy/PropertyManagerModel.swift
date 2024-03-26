//
//  PropertyManagerModel.swift
//  RentEasy
//
//  Created by Oladipupo Olasile on 2024-03-25.
//

import Foundation
import FirebaseFirestore

class PropertyManagerModel {
    static let shared = PropertyManagerModel()
    
    func fetchPropertyManagerDetails(by userID: String, completion: @escaping (Result<User, Error>) -> Void) {
           let db = Firestore.firestore()
           db.collection("users").document(userID).getDocument { documentSnapshot, error in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               guard let data = documentSnapshot?.data() else {
                   completion(.failure(NSError(domain: "NotFound", code: -1, userInfo: nil)))
                   return
               }
               let user = User(
                   id: userID,
                   firstName: data["firstName"] as? String ?? "",
                   lastName: data["lastName"] as? String ?? "",
                   email: data["email"] as? String ?? "",
                   phoneNumber: data["phoneNumber"] as? String ?? "",
                   profileImageUrl: data["profileImageUrl"] as? String
               )
               completion(.success(user))
           }
       }
}
