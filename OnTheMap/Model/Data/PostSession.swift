//
//  PostSession.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/2/24.
//

import Foundation

struct PostSession: Codable {
    let credentials: UserPass
    
    enum CodingKeys: String, CodingKey {
        case credentials = "udacity"
    }
}


struct UserPass: Codable {
    let username: String
    let password: String
}
