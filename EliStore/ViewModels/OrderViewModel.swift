//
//  OrderViewModel.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import Foundation
import Combine

class OrderViewModel {
    
    // MARK: - Internal properties
    var totalCostPublisher = CurrentValueSubject<Int, Never>(0)
    var orderDetailsSuccess = PassthroughSubject<Bool, Never>()
    var selectedProducts: [Product]!
    var client: HTTPClientProtocol
    var tokens = Set<AnyCancellable>()
    
    // MARK: - Initializers
    init(client: HTTPClientProtocol, products: [Product]) {
        self.client = client
        selectedProducts = updateProductCostPerQuantity(products)
        calculateTotalCost()
    }
    
    // MARK: - Helper Methods
    func calculateTotalCost() {
        var totalCost = 0
        for product in selectedProducts {
            let price = product.price.dropLast()
            totalCost = totalCost + (Int(price) ?? 0)
        }
        totalCostPublisher.send(totalCost)
    }
    
    func updateProductCostPerQuantity(_ products: [Product]) -> [Product] {
        var productsTemp = [Product]()
        for var product in products {
            let price = Int(product.price.dropLast())!
            let costPerQuantity = price * product.quantity
            product.price = "\(costPerQuantity)$"
            productsTemp.append(product)
        }
        return productsTemp
    }

    func postHttpOrderDetails(data: Data) {
        client.postOrdersRequest(data: data)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        debugPrint("Publisher stopped observing")
                    case .failure(let error):
                        debugPrint("This is any error passed to our future", error)
                    }
                },
                receiveValue: { [weak self] (result) in
                    self?.orderDetailsSuccess.send(result)
                }
            ).store(in: &tokens)
    }
    
    func saveOrderDetailsToJSONFile() {
        let pathDirectory = getDocumentsDirectory()
        try? FileManager().createDirectory(at: pathDirectory, withIntermediateDirectories: true)
        let filePath = pathDirectory.appendingPathComponent("Orders.json")
        let json = MockedData.ordersJSON.data
        do {
            try json.write(to: filePath)
            postHttpOrderDetails(data: json)
        } catch {
            debugPrint("Failed to write JSON data: \(error.localizedDescription)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
