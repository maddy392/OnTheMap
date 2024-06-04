//
//  PostSessionResponse.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/2/24.
//

import Foundation

struct PostSessionResponse: Codable {
    let account: Account
    let session: Session
    
}

struct Account: Codable {
    let registered: Bool
    let key: String
}

struct Session: Codable {
    let sessionId: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "id"
        case expiration
    }
}

struct PostSessionErrorResponse: Codable {
    let status: Int
    let errorMessage: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case errorMessage = "error"
    }
}

extension PostSessionErrorResponse: LocalizedError {
    var errorDescription: String? {
        return errorMessage
    }
}
