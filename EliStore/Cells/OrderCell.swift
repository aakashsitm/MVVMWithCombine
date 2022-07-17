//
//  OrderCell.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import Combine
import UIKit


class OrderCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!

    func populate(_ product: Product) {
        self.productImage.image = UIImage(named: product.image)
        self.productName.text = product.name
        self.productPrice.text = product.price
        self.productQuantity.text = "\(product.quantity)"
    }
}
