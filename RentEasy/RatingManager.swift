//
//  RatingManager.swift
//  RentEasy
//
//  Created by Oladipupo Olasile on 2024-03-24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Rating {
    var userID: String
    var firstName: String
    var lastName: String
    var value: Int
    var feedback: String
    
    var dictionary: [String: Any] {
        return [
            "userID": userID,
            "firstName": firstName,
            "lastName": lastName,
            "value": value,
            "feedback": feedback
        ]
    }
}

struct Testimonial {
    var name: String
    var comment: String
    var rating: Int
}


class RatingManager {
    static let shared = RatingManager()
    private let db = Firestore.firestore()
    
    func submitRating(forPosterUserID posterUserID: String, rating: Rating) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(posterUserID)
        
        userDocRef.collection("ratings").addDocument(data: rating.dictionary) { error in
            if let error = error {
                print("Error adding document-> \(error)")
            } else {
                print("Document posted")
            }
        }
    }
    
    
    func fetchRatings(for posterUserID: String, completion: @escaping ([Testimonial]) -> Void) {
           db.collection("users").document(posterUserID).collection("ratings").getDocuments { (querySnapshot, error) in
               if let error = error {
                   print("Error getting documents: \(error)")
                   completion([])
               } else {
                   let testimonials = querySnapshot?.documents.compactMap { document -> Testimonial? in
                       let data = document.data()
                       let value = data["value"] as? Int ?? 0
                       let feedback = data["feedback"] as? String ?? ""
                       let firstName = data["firstName"] as? String ?? ""
                       let lastName = data["lastName"] as? String ?? ""
                       return Testimonial(name: "\(firstName) \(lastName)", comment: feedback, rating: value)
                   } ?? []
                   completion(testimonials)
               }
           }
       }

}
