//
//  PropertyManager.swift
//  RentEasy
//
//  Created by Oladipupo Olasile on 2024-03-23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class PropertyManager {
    static let shared = PropertyManager()
    private let db = Firestore.firestore()
    
    func uploadProperty(_ property: Property, images: [UIImage], completion: @escaping (Bool, Error?) -> Void) {
        uploadImages(images) { [weak self] urls, error in
            guard let self = self, let urls = urls, error == nil else {
                completion(false, error)
                return
            }
            
            var propertyData = property.dictionary
            propertyData["imageUrls"] = urls

            self.db.collection("properties").addDocument(data: propertyData) { error in
                if let error = error {
                    completion(false, error)
                } else {
                    completion(true, nil)
                }
            }
        }
    }



    
    private func uploadImages(_ images: [UIImage], completion: @escaping ([String]?, Error?) -> Void) {
        let storageRef = Storage.storage().reference(withPath: "propertyImages")
        var imageUrls = [String]()
        let dispatchGroup = DispatchGroup()
        
        for image in images {
            guard let imageData = image.jpegData(compressionQuality: 0.75) else { continue }
            let imageName = UUID().uuidString + ".jpg"
            let imageRef = storageRef.child(imageName)
            
            dispatchGroup.enter()
            imageRef.putData(imageData, metadata: nil) { _, error in
                guard error == nil else {
                    dispatchGroup.leave()
                    completion(nil, error)
                    return
                }
                
                imageRef.downloadURL { url, error in
                    guard let downloadUrl = url?.absoluteString, error == nil else {
                        dispatchGroup.leave()
                        completion(nil, error)
                        return
                    }
                    
                    imageUrls.append(downloadUrl)
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(imageUrls, nil)
        }
    }
    
    
    //MARK: - FETCH PRODUCTS
    static func fetchAllProperties(completion: @escaping ([Property]?, Error?) -> Void) {
           let db = Firestore.firestore()
           db.collection("properties").getDocuments { (querySnapshot, err) in
               if let err = err {
                   print("Error getting documents: \(err)")
                   completion(nil, err)
               } else {
                   var propertiesArray = [Property]()
                   for document in querySnapshot!.documents {
                       let data = document.data()
                       let property = Property(
                        posterUserID: data["posterUserID"] as? String ?? "", propertyID: document.documentID, propertyName: data["propertyName"] as? String ?? "",
                           propertySize: data["propertySize"] as? String ?? "",
                           propertyAmount: data["propertyAmount"] as? Int ?? 0,
                           propertyCategory: data["propertyCategory"] as? String ?? "",
                           description: data["description"] as? String ?? "",
                           propertyAddress: data["propertyAddress"] as? String ?? "",
                           latitude: data["latitude"] as? Double ?? 0.0,
                           longitude: data["longitude"] as? Double ?? 0.0,
                           imageUrls: data["imageUrls"] as? [String] ?? [],
                        isNegotiable: data["isNegotiable"] as? Bool ?? false, 
                        isBooked: data["isBooked"] as? Bool ?? false
                       )
                       print("Fetched Property-> \(property)")
                       propertiesArray.append(property)
                   }
                   completion(propertiesArray, nil)
               }
           }
       }
    
    //MARK: - FAVE PRODUCTS
   static func fetchFavoritePropertyIds(completion: @escaping (Result<Set<String>, Error>) -> Void) {
       guard let userId = UserManager.shared.currentUserId else {
           completion(.failure(NSError(domain: "UserManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID not found"])))
           return
       }
       
       let db = Firestore.firestore()
       db.collection("users").document(userId).collection("favorites").getDocuments { snapshot, error in
           if let error = error {
               completion(.failure(error))
           } else {
               let ids = snapshot?.documents.map { $0.documentID } ?? []
               completion(.success(Set(ids)))
           }
       }
   }
    
    //MARK: - FAVORITE VIEW CONTROLLER METHOD
    static func fetchFavoriteProperties(byIds ids: Set<String>, completion: @escaping ([Property]) -> Void) {
        let db = Firestore.firestore()
        var properties = [Property]()

        let group = DispatchGroup()

        for id in ids {
            group.enter()
            db.collection("properties").document(id).getDocument { (document, error) in
                defer { group.leave() }
                
                if let document = document, document.exists {
                    let data = document.data()
                    let property = Property(
                        posterUserID: data?["posterUserID"] as? String ?? "",
                        propertyID: document.documentID,
                        propertyName: data?["propertyName"] as? String ?? "",
                        propertySize: data?["propertySize"] as? String ?? "",
                        propertyAmount: data?["propertyAmount"] as? Int ?? 0,
                        propertyCategory: data?["propertyCategory"] as? String ?? "",
                        description: data?["description"] as? String ?? "",
                        propertyAddress: data?["propertyAddress"] as? String ?? "",
                        latitude: data?["latitude"] as? Double ?? 0.0,
                        longitude: data?["longitude"] as? Double ?? 0.0,
                        imageUrls: data?["imageUrls"] as? [String] ?? [],
                        isNegotiable: data?["isNegotiable"] as? Bool ?? false, 
                        isBooked: data?["isBooked"] as? Bool ?? false
                        
                    )
                    properties.append(property)
                }
            }
        }

        group.notify(queue: .main) {
            completion(properties)
        }
    }

//MARK: - SEARCH FROM MAP VIEW
    func searchProperties(query: String, completion: @escaping ([Property]?, Error?) -> Void) {
        db.collection("properties")
            .whereField("propertyName", isGreaterThanOrEqualTo: query)
            .whereField("propertyName", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var properties: [Property] = []
                    querySnapshot?.documents.forEach { document in
                        let data = document.data()
                        if let propertyName = data["propertyName"] as? String,
                           let propertySize = data["propertySize"] as? String,
                           let propertyAmount = data["propertyAmount"] as? Int,
                           let propertyCategory = data["propertyCategory"] as? String,
                           let description = data["description"] as? String,
                           let propertyAddress = data["propertyAddress"] as? String,
                           let latitude = data["latitude"] as? Double,
                           let longitude = data["longitude"] as? Double,
                           let imageUrls = data["imageUrls"] as? [String],
                           let isNegotiable = data["isNegotiable"] as? Bool,
                           let isBooked = data["isBooked"] as? Bool {

                            let posterUserID = data["posterUserID"] as? String ?? "Unknown"
                            
                            let property = Property(posterUserID: posterUserID, propertyID: document.documentID, propertyName: propertyName,
                                                    propertySize: propertySize,
                                                    propertyAmount: propertyAmount,
                                                    propertyCategory: propertyCategory,
                                                    description: description,
                                                    propertyAddress: propertyAddress,
                                                    latitude: latitude,
                                                    longitude: longitude,
                                                    imageUrls: imageUrls,
                                                    isNegotiable: isNegotiable,
                                                    isBooked: isBooked)
                            properties.append(property)
                        }
                    }
                    completion(properties, nil)
                }
            }
    }


    
    //MARK: - SEARCH BY CATEGORIES
    func searchPropertiesByCategory(category: String, completion: @escaping ([Property]?, Error?) -> Void) {
          db.collection("properties")
              .whereField("propertyCategory", isEqualTo: category)
              .getDocuments { (querySnapshot, error) in
                  if let error = error {
                      completion(nil, error)
                  } else {
                      var properties: [Property] = []
                      for document in querySnapshot!.documents {
                          let data = document.data()
                          let property = Property(
                              posterUserID: data["posterUserID"] as? String ?? "",
                              propertyID: document.documentID,
                              propertyName: data["propertyName"] as? String ?? "",
                              propertySize: data["propertySize"] as? String ?? "",
                              propertyAmount: data["propertyAmount"] as? Int ?? 0,
                              propertyCategory: data["propertyCategory"] as? String ?? "",
                              description: data["description"] as? String ?? "",
                              propertyAddress: data["propertyAddress"] as? String ?? "",
                              latitude: data["latitude"] as? Double ?? 0.0,
                              longitude: data["longitude"] as? Double ?? 0.0,
                              imageUrls: data["imageUrls"] as? [String] ?? [],
                              isNegotiable: data["isNegotiable"] as? Bool ?? false, 
                              isBooked: data["isBooked"] as? Bool ?? false
                          )
                          properties.append(property)
                      }
                      completion(properties, nil)
                  }
              }
      }
    
    
    //MARK: - FETCH HISTORY DATA
    static func fetchHistoryProperties(byPosterID posterID: String, completion: @escaping ([Property]) -> Void) {
        let db = Firestore.firestore()
        db.collection("properties")
          .whereField("posterUserID", isEqualTo: posterID)
          .getDocuments { (querySnapshot, err) in
              if let err = err {
                  print("Error getting documents-> \(err)")
                  completion([])
              } else {
                  var properties: [Property] = []
                  for document in querySnapshot!.documents {
                      let data = document.data()
                      let property = Property(
                          posterUserID: data["posterUserID"] as? String ?? "",
                          propertyID: document.documentID,
                          propertyName: data["propertyName"] as? String ?? "",
                          propertySize: data["propertySize"] as? String ?? "",
                          propertyAmount: data["propertyAmount"] as? Int ?? 0,
                          propertyCategory: data["propertyCategory"] as? String ?? "",
                          description: data["description"] as? String ?? "",
                          propertyAddress: data["propertyAddress"] as? String ?? "",
                          latitude: data["latitude"] as? Double ?? 0.0,
                          longitude: data["longitude"] as? Double ?? 0.0,
                          imageUrls: data["imageUrls"] as? [String] ?? [],
                          isNegotiable: data["isNegotiable"] as? Bool ?? false,
                          isBooked: data["isBooked"] as? Bool ?? false
                      )
                      properties.append(property)
                  }
                  completion(properties)
              }
          }
    }
    
    //MARK: - SLIDER SEARCH
    func fetchPropertiesWithPriceLessThanOrEqual(to amount: Int, completion: @escaping ([Property]?, Error?) -> Void) {
           db.collection("properties")
               .whereField("propertyAmount", isLessThanOrEqualTo: amount)
               .getDocuments { querySnapshot, error in
                   if let error = error {
                       print("Error fetching properties-> \(error.localizedDescription)")
                       completion(nil, error)
                   } else {
                       var properties: [Property] = []
                       for document in querySnapshot!.documents {
                           let data = document.data()
                           guard let propertyName = data["propertyName"] as? String,
                                 let propertySize = data["propertySize"] as? String,
                                 let propertyAmount = data["propertyAmount"] as? Int,
                                 let propertyCategory = data["propertyCategory"] as? String,
                                 let description = data["description"] as? String,
                                 let propertyAddress = data["propertyAddress"] as? String,
                                 let latitude = data["latitude"] as? Double,
                                 let longitude = data["longitude"] as? Double,
                                 let imageUrls = data["imageUrls"] as? [String],
                                 let isNegotiable = data["isNegotiable"] as? Bool,
                                 let isBooked = data["isBooked"] as? Bool else {
                               continue
                           }
                           
                           let property = Property(posterUserID: "", propertyID: document.documentID, propertyName: propertyName, propertySize: propertySize, propertyAmount: propertyAmount, propertyCategory: propertyCategory, description: description, propertyAddress: propertyAddress, latitude: latitude, longitude: longitude, imageUrls: imageUrls, isNegotiable: isNegotiable, isBooked: isBooked)
                           properties.append(property)
                       }
                       completion(properties, nil)
                   }
               }
       }
}
