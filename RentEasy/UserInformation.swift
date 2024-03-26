//
//  UserDetails.swift
//  RentEasy
//
//  Created by CodeSOMPs on 2023-11-11.
//

import Foundation


struct UserInformation: Codable {
    var emailAddress: String
    var password: String
    var firstName: String
    var lastName: String
    var phoneNumber: Int
}
