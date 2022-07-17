//
//  OrderDetailsVC.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import UIKit
import Combine

class OrderDetailsVC: UIViewController {

    // MARK: - UI outlets
    @IBOutlet weak var tblProducts: UITableView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnOrderConfirm: UIButton!
    @IBOutlet weak var activityIndicatorOrders: UIActivityIndicatorView!
    @IBOutlet weak var lblTotalCost: UILabel!
    
    // MARK: - Internal properties
    var viewModel: OrderViewModel!
    var tokens = Set<AnyCancellable>()
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        title = Constants.order
        self.btnOrderConfirm.isEnabled = false
        self.btnOrderConfirm.alpha = 0.5
        self.txtAddress.delegate = self
        self.activityIndicatorOrders.stopAnimating()
    }
    
    // MARK: Binding method
    
    func bindToViewModel() {
        viewModel.totalCostPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] cost in
                self?.lblTotalCost.text = "\(cost)$"

        }).store(in: &tokens)
        
        viewModel.orderDetailsSuccess
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] result in
                if result {
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let successVC = storyBoard.instantiateViewController(withIdentifier: "SuccessVC") as! SuccessVC
                    self?.navigationController?.pushViewController(successVC, animated: true)
                }

        }).store(in: &tokens)
    }
    
    // MARK: Setup Action methods

    @IBAction func confirmOrderAction(_ sender: UIButton) {
        self.activityIndicatorOrders.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.saveOrderDetailsToJSONFile()
        }
    }
    
    @IBAction func addressAction(_ sender: UITextField) {
        self.btnOrderConfirm.isEnabled = sender.state.isEmpty ? true : false
        self.btnOrderConfirm.alpha = sender.state.isEmpty ? 1.0 : 0.5
    }
}

extension OrderDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.selectedProducts.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell

        let product = viewModel.selectedProducts[indexPath.row]
        cell.populate(product)

        return cell
    }
    
}

extension OrderDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
