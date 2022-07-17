//
//  MockedHTTPClient.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation
import Combine
@testable import EliStore

class MockedHTTPClient: HTTPClientProtocol {
    func getProducts() -> Future<Products?, Error> {
        return Future { promise in
            let productModel = try! JSONDecoder().decode(Products.self, from:  MockedData.productsJSON.data)
            promise(.success(productModel))
        }
    }
    
    
    func getStoreDetails() -> Future<StoreInfo?, Error> {
        return Future { promise in
            let storeModel = try! JSONDecoder().decode(StoreInfo.self, from:  MockedData.storeInfoJSON.data)
            promise(.success(storeModel))
        }
    }
    
    func postOrdersRequest(data: Data) -> Future<Bool, Error> {
        return Future { promise in
            promise(.success(true))
        }
    }
}
