//
//  ProductDetailViewController.swift
//  AkakceCaseStudy-iOS
//
//  Created by Mustafa Pekdemir on 8.04.2025.
//

import UIKit
import SDWebImage

class ProductDetailViewController: UIViewController {
    
    private let productId: Int
    private var product: Product?
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let ratingLabel = UILabel()
    
    init(productId: Int) {
        self.productId = productId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product Detail"
        view.backgroundColor = .white
        setupUI()
        fetchProduct()
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        [imageView, titleLabel, priceLabel, descriptionLabel, ratingLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.contentMode = .scaleAspectFit
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 0
        priceLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        priceLabel.textColor = .red
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        ratingLabel.font = .systemFont(ofSize: 13)
        ratingLabel.textColor = .darkGray

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 250),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8),
            ratingLabel.leadingAnchor.constraint(equalTo: priceLabel.leadingAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func fetchProduct() {
        NetworkManager.shared.fetchProductDetail(id: productId) { [weak self] result in
            switch result {
            case .success(let product):
                self?.product = product
                self?.configure(with: product)
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    private func configure(with product: Product) {
        imageView.sd_setImage(with: URL(string: product.image))
        titleLabel.text = product.title
        priceLabel.text = String(format: "$%.2f", product.price)
        descriptionLabel.text = product.description
        ratingLabel.text = "Rating: \(product.rating.rate) (\(product.rating.count) ❤️)"
    }
}
