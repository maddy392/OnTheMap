//
//  postStudentLocation.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/7/24.
//

import Foundation

struct PostStudentLocation: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}

struct PostStudentLocationResponse: Codable {
    let objectId: String
    let createdAt: String
}

struct PostStudentLocationErrorResponse: Codable {
    let code: Int
    let error: String
}

extension PostStudentLocationErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
