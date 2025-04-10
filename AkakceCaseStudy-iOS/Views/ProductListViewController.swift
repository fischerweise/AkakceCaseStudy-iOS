//
//  ProductListViewController.swift
//  AkakceCaseStudy-iOS
//
//  Created by Mustafa Pekdemir on 8.04.2025.
//

import UIKit
import SDWebImage

class ProductListViewController: UIViewController {
    
    private let viewModel = ProductListViewModel()
    
    private let horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private let gridCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 10
        let width = (UIScreen.main.bounds.width - (spacing * 3)) / 2
        layout.itemSize = CGSize(width: width, height: 180)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        view.backgroundColor = .white
        setupUI()
        setupBindings()
        viewModel.fetchProducts()
    }
    private func setupUI() {
        horizontalCollectionView.dataSource = self
        horizontalCollectionView.delegate = self
        horizontalCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        
        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridCollectionView.register(ProductCell.self, forCellWithReuseIdentifier: "ProductCell")
        
        view.addSubview(horizontalCollectionView)
        view.addSubview(gridCollectionView)
        
        horizontalCollectionView.translatesAutoresizingMaskIntoConstraints = false
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horizontalCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            horizontalCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            gridCollectionView.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 16),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupBindings() {
        viewModel.onDataFetched = { [weak self] in
            self?.horizontalCollectionView.reloadData()
            self?.gridCollectionView.reloadData()
        }
        
        viewModel.onError = { error in
            print("Error: \(error)")
        }
    }
}

extension ProductListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCollectionView {
            return viewModel.numberOfHorizontalItems()
        } else {
            return viewModel.numberOfGridItems()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            return UICollectionViewCell()
        }
        
        let product: Product?
        if collectionView == horizontalCollectionView {
            product = viewModel.horizontalProduct(at: indexPath.item)
        } else {
            product = viewModel.gridProduct(at: indexPath.item)
        }
        
        if let product = product {
            cell.configure(with: product)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product: Product?
        if collectionView == horizontalCollectionView {
            product = viewModel.horizontalProduct(at: indexPath.item)
        } else {
            product = viewModel.gridProduct(at: indexPath.item)
        }
        
        if let product = product {
            let detailVC = ProductDetailViewController(productId: product.id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
