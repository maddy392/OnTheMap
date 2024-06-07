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
        case getStudentList
        
        var stringValue: String {
            switch self {
            case .postSession: return Endpoints.basePath + Endpoints.postSessionPath
            case .getStudentList: return Endpoints.basePath + "/StudentLocation?limit=100&order=-updatedAt"
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
    
    class func deleteSession() {
        // same url as posting a session
        var request = URLRequest(url: Endpoints.postSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" {
                xsrfCookie = cookie
            }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard var data = data else {
                return
            }
            
            data = data.dropFirst(5)
            let decoder = JSONDecoder()
            do {
                let _ = try decoder.decode(DeleteSessionResponse.self, from: data)
//                print(responseObject)
                print("Deleting Session")
//                print("Auth Session Id before deleting: \(Auth.sessionId)")
                Auth.sessionId = ""
                print("Auth Session Id after deleting: \(Auth.sessionId)")
            } catch {
                print("Decode Error")
            }
        }
        task.resume()
    }
    
    class func getStudentList(completionHandler: @escaping ([Student], Error?) -> Void) {
//        print("Making a getStudentcall")
        let task = URLSession.shared.dataTask(with: Endpoints.getStudentList.url) {
            data, response, error in
            guard let data = data else {
//                print("guard statement failed")
                completionHandler([], error)
                return
            }
            
//            print(String(data: data, encoding: .utf8)!)
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GetStudentResults.self, from: data)
                let students = responseObject.results
//                print(students)
                completionHandler(students, nil)
            } catch {
//                print("Decode failed")
                completionHandler([], error)
            }
        }
        task.resume()
    }
}
