//
//  StoreViewModel.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import Foundation
import Combine

class StoreViewModel {
    
    // MARK: - Internal properties
    var storeInfoPublisher = PassthroughSubject<StoreInfo, Never>()
    var productsTableReload = PassthroughSubject<Void, Never>()
    var products = [Product]()
    var selectedProducts = [Product]()
    var tokens = Set<AnyCancellable>()
    var client: HTTPClientProtocol
    
    // MARK: - Initializers
    init(client: HTTPClientProtocol) {
        self.client = client
    }
    
    // MARK: - Helper Methods
    func getStoreDetails() {
        self.client.getStoreDetails()
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        debugPrint("Publisher stopped observing")
                    case .failure(let error):
                        debugPrint("This is any error passed to our future", error)
                    }
                },
                receiveValue: { [weak self] (storeInfo) in
                    if let storeInfo = storeInfo {
                        self?.storeInfoPublisher.send(storeInfo)
                    }
                }
            ).store(in: &tokens)
    }
    
    func getProducts() {
        self.client.getProducts()
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        debugPrint("Publisher stopped observing")
                    case .failure(let error):
                        debugPrint("This is any error passed to our future", error)
                    }
                },
                receiveValue: { [weak self] (productInfo) in
                    if let productInfo = productInfo {
                        self?.selectedProducts = []
                        self?.products = productInfo.products
                        self?.productsTableReload.send(())
                    }
                }
            ).store(in: &tokens)
    }
}
