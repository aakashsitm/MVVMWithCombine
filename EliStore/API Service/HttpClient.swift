//
//  HTTPClient.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation
import Combine
import Mocker

class HTTPClient: HTTPClientProtocol {
    
    func getStoreDetails() -> Future<StoreInfo?, Error> {

        return Future { promise in
            let storeRequestUrl = URL(string: ApiEndpoints.storeInfo)!
            Mock(url: storeRequestUrl, dataType: .json, statusCode: 200, data: [
                .get: MockedData.storeInfoJSON.data
            ]
            ).register()
            HttpUtility.getApiData(requestUrl: storeRequestUrl, resultType: StoreInfo.self) { result in
                switch result {
                case .success(let storeInfo):
                    promise(.success(storeInfo))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func getProducts() -> Future<Products?, Error> {
        return Future { promise in
            let storeRequestUrl = URL(string: ApiEndpoints.products)!
            Mock(url: storeRequestUrl, dataType: .json, statusCode: 200, data: [
                .get: MockedData.productsJSON.data
            ]
            ).register()
            HttpUtility.getApiData(requestUrl: storeRequestUrl, resultType: Products.self) { result in
                switch result {
                case .success(let storeInfo):
                    promise(.success(storeInfo))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
    func postOrdersRequest(data: Data) -> Future<Bool, Error> {
        return Future { promise in
            let orderRequestUrl = URL(string: ApiEndpoints.orderDone)!
            Mock(url: orderRequestUrl, dataType: .json, statusCode: 200, data: [
                .post: data
            ]
            ).register()
            HttpUtility.postApiData(requestUrl: orderRequestUrl, requestBody: data, resultType: Orders.self) { result in
                switch result {
                case .success(let saved):
                    promise(.success(saved))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    
}

