//
//  ProductListViewModel.swift
//  AkakceCaseStudy-iOS
//
//  Created by Mustafa Pekdemir on 8.04.2025.
//

import Foundation

final class ProductListViewModel {
    
    private(set) var horizontalProducts: [Product] = []
    private(set) var products: [Product] = []
    
    var onDataFetched: (() -> Void)?
    var onError: ((NetworkError) -> Void)?
    
    func fetchProducts() {
        fetchHorizontalProducts()
        fetchAllProducts()
    }
    
    private func fetchHorizontalProducts() {
        NetworkManager.shared.fetchHorizontalProducts(limit: 5) { [weak self] result in
            switch result {
            case .success(let products):
                self?.horizontalProducts = products
                self?.onDataFetched?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    private func fetchAllProducts() {
        NetworkManager.shared.fetchAllProducts { [weak self] result in
            switch result {
            case .success(let products):
                self?.products = products
                self?.onDataFetched?()
            case .failure(let error):
                self?.onError?(error)
            }
        }
    }
    
    func numberOfHorizontalItems() -> Int {
        return horizontalProducts.count
    }
    
    func numberOfGridItems() -> Int {
        return products.count
    }
    
    func horizontalProduct(at index: Int) -> Product? {
        guard index < horizontalProducts.count else { return nil }
        return horizontalProducts[index]
    }
    
    func gridProduct(at index: Int) -> Product? {
        guard index < products.count else { return nil }
        return products[index]
    }
}
