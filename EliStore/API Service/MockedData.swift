//
//  MockedData.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation

public final class MockedData {
    public static let storeInfoJSON: URL = Bundle.module.url(forResource: "StoreInfo", withExtension: "json")!
    public static let productsJSON: URL = Bundle.module.url(forResource: "Products", withExtension: "json")!
    public static let ordersJSON: URL = Bundle.module.url(forResource: "Orders", withExtension: "json")!
}

extension Bundle {
    static let module = Bundle(for: MockedData.self)
}

extension URL {
    var data: Data {
        return try! Data(contentsOf: self)
    }
}
