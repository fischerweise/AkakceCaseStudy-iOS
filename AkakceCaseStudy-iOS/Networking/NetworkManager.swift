//
//  NetworkManager.swift
//  AkakceCaseStudy-iOS
//
//  Created by Mustafa Pekdemir on 8.04.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(Error)
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://fakestoreapi.com/products"
    
    func fetchHorizontalProducts(limit: Int = 5, completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)?limit=\(limit)") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    func fetchAllProducts(completion: @escaping (Result<[Product], NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    func fetchProductDetail(id: Int, completion: @escaping (Result<Product, NetworkError>) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(id)") else {
            completion(.failure(.invalidURL))
            return
        }
        fetch(url: url, completion: completion)
    }
    
    private func fetch<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(.serverError(error)))
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.noData))
                }
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}
