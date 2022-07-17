//
//  ProductCell.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import Combine
import UIKit


class ProductCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var productQuantityObserver = PassthroughSubject<ProductAction, Never>()
    
    @IBAction func productsUpdateAction(_ sender: UIStepper) {
        if(Int(sender.value) > 0){
            productQuantityObserver.send(.productIncrement(Int(sender.value)))
        }
        else{
            productQuantityObserver.send(.productDecrement(Int(sender.value)))
        }
    }
    
    func populate(_ product: Product) {
        self.productImage.image = UIImage(named: product.image)
        self.productName.text = product.name
        self.productPrice.text = product.price
    }
}

extension ProductCell {
    enum ProductAction {
        case productIncrement(Int)
        case productDecrement(Int)
    }
}
