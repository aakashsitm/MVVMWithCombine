//
//  Order.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import Foundation

struct Orders : Codable
{
    let orders: [Order]
}

struct Order : Codable
{
    let name: String
    let image: String
    var price: String
    var quantity: Int
}
