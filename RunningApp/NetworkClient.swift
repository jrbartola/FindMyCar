//
//  NetworkClient.swift
//  RunningApp
//
//  Created by Jesse Bartola on 7/19/17.
//  Copyright © 2017 runners. All rights reserved.
//

import Foundation

class NetworkClient {
    
    var request: URLRequest
    var method: String
    let session = URLSession.shared
    
    init(url: String, httpMethod: String) {
        self.request = URLRequest(url: URL(string: url)!)
        self.method = httpMethod
    }
    
    func createSession(withCallback callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        session.dataTask(with: self.request, completionHandler: callback).resume()
        
    }
}
