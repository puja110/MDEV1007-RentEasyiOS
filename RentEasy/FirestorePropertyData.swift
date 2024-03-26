//
//  SessionTasksData.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-15.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore


struct Property {
    var posterUserID: String
    var propertyID: String?
    var propertyName: String
    var propertySize: String
    var propertyAmount: Int
    var propertyCategory: String
    var description: String
    var propertyAddress: String
    var latitude: Double
    var longitude: Double
    var imageUrls: [String] = []
    var isNegotiable: Bool
    var isBooked: Bool
}

//var properties: [Property] = [
//    Property(propertyName: "Two Bedroom Flat", propertySize: "Two bedroom", propertyAmount: 1000, propertyCategory: "Condo", description: "", propertyAddress: "67 Sophia St", latitude: 44.39393662891747, longitude: -79.68782193201106, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "DownTown Mini House", propertySize: "One room", propertyAmount: 2000, propertyCategory: "Contemporary", description: "", propertyAddress: "98 Clapperton St", latitude: 44.394390537718486, longitude: -79.69177713358985, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Three Bedroom Condo", propertySize: "Three rooms", propertyAmount: 1200, propertyCategory: "Family Home", description: "", propertyAddress: "30 Wellington St E", latitude: 44.394841793994836, longitude: -79.69235078968296, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Three bedroom Duplex", propertySize: "Three rooms", propertyAmount: 2000, propertyCategory: "Contemporary", description: "", propertyAddress: "15 Grove St E", latitude: 44.39710332221014, longitude: -79.69553627619078, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Student Shared room", propertySize: "One room", propertyAmount: 1300, propertyCategory: "Family Home", description: "", propertyAddress: "163A Owen St", latitude: 44.39692173565016, longitude: -79.69086939012152, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Shared Home", propertySize: "One room", propertyAmount: 1100, propertyCategory: "Family Home", description: "", propertyAddress: "Murray's Windermere Gardens", latitude: 44.395809210907245, longitude: -79.6883655062772, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Single basement room", propertySize: "One room", propertyAmount: 3000, propertyCategory: "Student Home", description: "", propertyAddress: "94 B Wellington St E", latitude: 44.39699332946598, longitude: -79.68762335839357, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Two rooms shared", propertySize: "Two bedroom", propertyAmount: 3000, propertyCategory: "Condo", description: "", propertyAddress: "178 Owen St Unit I", latitude: 44.39706848086475, longitude: -79.69239723365371, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Three bedroom House", propertySize: "Three rooms", propertyAmount: 900, propertyCategory: "Contemporary", description: "", propertyAddress: "67 Sophia Street E", latitude: 44.394150275209235, longitude: -79.68791825808138, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Rooftop view House", propertySize: "One room", propertyAmount: 800, propertyCategory: "Contemporary", description: "", propertyAddress: "36 Dalton St", latitude: 44.39500855640846, longitude: -79.69770367777834, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Shared condo House", propertySize: "One room", propertyAmount: 1000, propertyCategory: "Family Home", description: "", propertyAddress: "50 Rodney St", latitude: 44.3941049659377, longitude: -79.6717866301592, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Rooftop Vista Quarters: Four Rooms & Three Bedrooms", propertySize: "Four rooms", propertyAmount: 700, propertyCategory: "Student Home", description: "", propertyAddress: "225 Cardinal St", latitude: 44.41529584868266, longitude: -79.6932893722218, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Five rooms duplex", propertySize: "Five rooms", propertyAmount: 650, propertyCategory: "Condo", description: "", propertyAddress: "28 Hadden Crescent", latitude: 44.413410608155544, longitude: -79.69505963015818, imageUrls: [], isNegotiable: false),
//    
//    Property(propertyName: "Zenith Haven: Four-Room Rooftop Residence", propertySize: "Four rooms", propertyAmount: 800, propertyCategory: "Contemporary", description: "", propertyAddress: "34 Roslyn Rd", latitude: 44.40935186496082, longitude: -79.67701936560793, imageUrls: [], isNegotiable: false)
//]


extension Property {
    var dictionary: [String: Any] {
        [
            "posterUserID": posterUserID,
            "propertyName": propertyName,
            "propertySize": propertySize,
            "propertyAmount": propertyAmount,
            "propertyCategory": propertyCategory,
            "description": description,
            "propertyAddress": propertyAddress,
            "latitude": latitude,
            "longitude": longitude,
            "imageUrls": imageUrls,
            "isNegotiable": isNegotiable,
            "isBooked": isBooked
        ]
    }
}

//extension Property {
//    static func uploadAllProperties() {
//        let db = Firestore.firestore()
//        
//        properties.forEach { property in
//            db.collection("properties").addDocument(data: property.dictionary) { error in
//                if let error = error {
//                    print("Error uploading property \(property.propertyName)- \(error.localizedDescription)")
//                } else {
//                    print("Successfully uploaded property \(property.propertyName)")
//                }
//            }
//        }
//    }
//}
