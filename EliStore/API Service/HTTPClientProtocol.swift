//
//  HTTPClientProtocol.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation
import Combine

protocol HTTPClientProtocol {
    func getStoreDetails() -> Future<StoreInfo?, Error>;
    func getProducts() -> Future<Products?, Error>;
    func postOrdersRequest(data: Data) -> Future<Bool, Error>;
}

