//
//  SuccessVC.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import UIKit

class SuccessVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.successPage
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        self.navigationController?.removeViewController(StoreDetailsVC.self)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let successVC = storyBoard.instantiateViewController(withIdentifier: "StoreDetailsVC") as! StoreDetailsVC
        self.navigationController?.pushViewController(successVC, animated: true)
    }

}
