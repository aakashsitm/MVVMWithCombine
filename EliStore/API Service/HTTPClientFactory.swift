//
//  HTTPClientFactory.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation

class HTTPClientFactory {
    
    static func create() -> HTTPClientProtocol {
        
        let enviromment = ProcessInfo.processInfo.environment["ENV"]
        if enviromment == "TEST" {
            return MockedHTTPClient()
        } else {
            return HTTPClient()
        }
    }
    
}
