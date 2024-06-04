//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Madhu Babu Adiki on 6/2/24.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
        static var udacityAccountId = ""
    }
    
    enum Endpoints {
        static let basePath = "https://onthemap-api.udacity.com/v1"
        static let postSessionPath = "/session"
        
        case postSession
        
        var stringValue: String {
            switch self {
            case .postSession: return Endpoints.basePath + Endpoints.postSessionPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func udacityLogin(username: String, password: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.postSession.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(PostSession(credentials: UserPass(username: username, password: password)))
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard var data = data else {
                completionHandler(false, error)
                return
            }
            data = data.dropFirst(5)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(PostSessionResponse.self, from: data)
                Auth.sessionId = responseObject.session.sessionId
                completionHandler(true, nil)
            } catch {
                do {
                    let errorResponse = try decoder.decode(PostSessionErrorResponse.self, from: data)
                    print(errorResponse.errorMessage)
                    completionHandler(false, errorResponse)
                } catch {
                    completionHandler(false, error)
                }
//                print("Decode error")
//                completionHandler(false, error)
            }
        }
    task.resume()
    }
}
