//
//  ContactsAPI.swift
//  ContactsDirectory
//
//  Created by Karen Muñoz on 30/11/17.
//  Copyright © 2017 Karen. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]
typealias completionHandler = (_ success: Bool, _ json: [JSON]) -> Void

class ContactsAPI {
    // Base URL for Contacts API endpoints
    private static let baseURL = "http://www.filltext.com/"
    
    // Returns endpoints URLs
    enum Endpoints {
        case Contacts
        func getList() -> String {
            switch self {
                case .Contacts: return "\(baseURL)?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true"
            }
        }
    }
    
    // HTTP request executer. Returns JSON array
    class func request(request: URLRequest, completion: @escaping completionHandler) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [JSON]
 
                    if let json = jsonSerialized {
                        completion(true, json)
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
                completion(false, [JSON()])
            }
        })
        task.resume()
    }
}
