//
//  Extensions.swift
//  EliStore
//
//  Created by Akash Verma on 15/07/22.
//

import UIKit

extension UINavigationController {
    
    func removeViewController(_ controller: UIViewController.Type) {
        if let viewController = self.viewControllers.first(where: { $0.isKind(of: controller.self) }) {
            viewController.removeFromParent()
        }
    }
}
