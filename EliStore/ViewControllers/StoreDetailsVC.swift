//
//  StoreDetailsVC.swift
//  EliStore
//
//  Created by Akash Verma on 17/07/22.
//

import UIKit
import Combine

class StoreDetailsVC: UIViewController {

    // MARK: - UI outlets
    @IBOutlet weak var tblProducts: UITableView!
    @IBOutlet weak var viewStoreInfo: UIView!
    @IBOutlet weak var productsActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imgViewStore: UIImageView!
    @IBOutlet weak var storeActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblStoreDesc: UILabel!
    
    // MARK: - Internal properties
    var viewModel: StoreViewModel!
    var tokens = Set<AnyCancellable>()
    
    // MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindToViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        title = Constants.store
        viewModel = StoreViewModel(client: HTTPClientFactory.create())
        self.btnAddToCart.isEnabled = viewModel.selectedProducts.count > 0 ? true : false
        self.btnAddToCart.alpha = viewModel.selectedProducts.count > 0 ? 1.0 : 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.viewModel.getStoreDetails()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.viewModel.getProducts()
        }
    }
    
    // MARK: Binding method
    
    func bindToViewModel() {
        // Binding feedback texts
        viewModel.storeInfoPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] storeInfo in
                self?.imgViewStore.image = UIImage(named: storeInfo.image)
                self?.lblStoreName.text = storeInfo.name
                self?.lblStoreDesc.text = storeInfo.desc
                self?.storeActivityIndicator.stopAnimating()
        }).store(in: &tokens)
        
        viewModel.productsTableReload
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.tblProducts.reloadData()
                self?.productsActivityIndicator.stopAnimating()
        }).store(in: &tokens)

    }
    
    // MARK: Setup Action methods

    @IBAction func AddToCartAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let orderDetailsVC = storyBoard.instantiateViewController(withIdentifier: "OrderDetailsVC") as! OrderDetailsVC
        orderDetailsVC.viewModel = OrderViewModel(client: HTTPClientFactory.create(), products: viewModel.selectedProducts)
        self.navigationController?.pushViewController(orderDetailsVC, animated: true)
    }
    
}

extension StoreDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.products.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductCell

        let product = viewModel.products[indexPath.row]
        cell.populate(product)
        
        cell.productQuantityObserver
            .receive(on: DispatchQueue.main)
            .sink { productAction in
                switch productAction {
                case .productIncrement(let quantity):
                    cell.productQuantity.text = "\(quantity)"
                    if var existingProduct = self.viewModel.selectedProducts.first(where: {$0.name == product.name}) {
                        existingProduct.quantity = quantity
                        if let index = self.viewModel.selectedProducts.firstIndex(where: {$0.name == product.name}) {
                            self.viewModel.selectedProducts[index] = existingProduct
                        }
                    } else {
                        self.viewModel.selectedProducts.append(product)
                    }
                    
                case .productDecrement(let quantity):
                    cell.productQuantity.text = quantity != 0 ? "\(quantity)" : "Add"
                    if let index = self.viewModel.selectedProducts.firstIndex(of: product) {
                        self.viewModel.selectedProducts.remove(at: index)
                    }
                }
                self.btnAddToCart.isEnabled = self.viewModel.selectedProducts.count > 0 ? true : false
                self.btnAddToCart.alpha = self.viewModel.selectedProducts.count > 0 ? 1.0 : 0.5
            }.store(in: &tokens)

        return cell
    }
    
}

