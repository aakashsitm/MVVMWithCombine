//
//  Product.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import Foundation


struct Products : Codable
{
    let products: [Product]
}

struct Product : Codable, Equatable
{
    let name: String
    let image: String
    var price: String
    var quantity: Int 
}
