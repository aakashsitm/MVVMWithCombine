//
//  StoreViewTests.swift
//  EliStoreTests
//
//  Created by Akash Verma on 17/07/22.
//

import XCTest
import Combine
@testable import EliStore

class StoreViewTests: XCTestCase {

    // MARK: - Internal properties
    var tokens = Set<AnyCancellable>()
    var storeViewModel: StoreViewModel?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        storeViewModel = StoreViewModel(client: MockedHTTPClient())
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        storeViewModel = nil
    }

    func testStoreInfoData() {
        let expectation = self.expectation(description: "Store Info request should succeed")
        storeViewModel?.client.getStoreDetails()
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
                receiveValue: { (storeInfo) in
                    if let storeInfo = storeInfo {
                        XCTAssertEqual(storeInfo.name, "Apple App Store")
                        XCTAssertEqual(storeInfo.desc, "Please note that face masks are recommended while visiting this location. If you need one, just ask.")
                        XCTAssertEqual(storeInfo.image, "appStore.jpeg")
                    } else {
                        XCTFail("StoreInfo is nil")
                    }
                    expectation.fulfill()
                }
            ).store(in: &tokens)
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testGetStoreDetails() {
        let expectation = self.expectation(description: "Store Info request should succeed")
        storeViewModel?.storeInfoPublisher
            .sink(receiveValue: { storeInfo in
                XCTAssertEqual(storeInfo.name, "Apple App Store")
                XCTAssertEqual(storeInfo.desc, "Please note that face masks are recommended while visiting this location. If you need one, just ask.")
                XCTAssertEqual(storeInfo.image, "appStore.jpeg")
                expectation.fulfill()
        }).store(in: &tokens)
        storeViewModel?.getStoreDetails()
        waitForExpectations(timeout: 10.0, handler: nil)
    }
    
    func testProducts() {
        let expectation = self.expectation(description: "Product details request should succeed")
        storeViewModel?.client.getProducts()
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
                receiveValue: { (productInfo) in
                    if let productInfo = productInfo {
                        XCTAssertNotNil(productInfo.products)
                        XCTAssertTrue(productInfo.products.count>0)
                        let product = productInfo.products.first
                        XCTAssertEqual(product?.name, "iPhone 13 Pro Max")
                        XCTAssertEqual(product?.image, "iphone13ProMax.png")
                        XCTAssertEqual(product?.price, "180000$")
                        XCTAssertEqual(product?.quantity, 1)
                    } else {
                        XCTFail("Product details is nil")
                    }
                    expectation.fulfill()
                }
            ).store(in: &tokens)
        waitForExpectations(timeout: 10.0, handler: nil)
    }

    func testGetProducts() {
        let expectation = self.expectation(description: "Product details request should succeed")
        storeViewModel?.productsTableReload
            .sink(receiveValue: {[weak self] _ in
                XCTAssertNotNil(self?.storeViewModel?.products)
                XCTAssertTrue((self?.storeViewModel?.products.count)!>0)
                let product = self?.storeViewModel?.products.first
                XCTAssertEqual(product?.name, "iPhone 13 Pro Max")
                XCTAssertEqual(product?.image, "iphone13ProMax.png")
                XCTAssertEqual(product?.price, "180000$")
                XCTAssertEqual(product?.quantity, 1)
                expectation.fulfill()
        }).store(in: &tokens)
        storeViewModel?.getProducts()
        waitForExpectations(timeout: 10.0, handler: nil)
    }

}
