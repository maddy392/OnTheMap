//
//  getPublicUserDataResponse.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/7/24.
//

import Foundation

struct UserPublicData: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
