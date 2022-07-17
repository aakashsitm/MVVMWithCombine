//
//  OrderViewTests.swift
//  EliStoreTests
//
//  Created by Akash Verma on 17/07/22.
//

import XCTest
import Combine
@testable import EliStore

class OrderViewTests: XCTestCase {

    // MARK: - Internal properties
    var tokens = Set<AnyCancellable>()
    var orderViewModel: OrderViewModel?
    var selectedProducts: [Product]!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let product1 = Product(name: "iPhone", image: "iphone.png", price: "500$", quantity: 1)
        let product2 = Product(name: "Macbook", image: "macbook.png", price: "100$", quantity: 1)
        selectedProducts = [product1, product2]
        orderViewModel = OrderViewModel(client: MockedHTTPClient(), products: selectedProducts)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        orderViewModel = nil
    }

    func testCalculateTotalCost() {
        orderViewModel?.calculateTotalCost()
        orderViewModel?.totalCostPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { cost in
                XCTAssertTrue(cost == 600)
        }).store(in: &tokens)
    }
    
    func testUpdateProductCostPerQuantity() {
        
        let product1 = Product(name: "iPhone", image: "iphone.png", price: "500$", quantity: 3)
        let product2 = Product(name: "Macbook", image: "macbook.png", price: "100$", quantity: 2)
        let selectedProductsTemp = [product1, product2]
        selectedProducts = orderViewModel?.updateProductCostPerQuantity(selectedProductsTemp)
        orderViewModel?.calculateTotalCost()
        orderViewModel?.totalCostPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { cost in
                XCTAssertTrue(cost == 1700)
        }).store(in: &tokens)
    }

    func testOrderDetails() {
        let expectation = self.expectation(description: "Post order details request should succeed")
        orderViewModel?.client.postOrdersRequest(data: MockedData.ordersJSON.data)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        debugPrint("Publisher stopped observing")
                    case .failure(let error):
                        XCTFail("Wrong data response \(error.localizedDescription)")
                        expectation.fulfill()
                    }
                },
                receiveValue: { (result) in
                    XCTAssertTrue(result)
                    expectation.fulfill()
                }
            ).store(in: &tokens)
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testPostHttpOrderDetails() {
        let expectation = self.expectation(description: "Post order details request should succeed")
        orderViewModel?.orderDetailsSuccess
            .sink(receiveValue: { result in
                XCTAssertTrue(result)
                expectation.fulfill()
        }).store(in: &tokens)
        orderViewModel?.postHttpOrderDetails(data: MockedData.ordersJSON.data)
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testSaveOrderDetailsToJSONFile() {
        let expectation = self.expectation(description: "Order details saved successfully")
        orderViewModel?.orderDetailsSuccess
            .sink(receiveValue: { result in
                XCTAssertTrue(result)
                expectation.fulfill()
        }).store(in: &tokens)
        orderViewModel?.saveOrderDetailsToJSONFile()
        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
