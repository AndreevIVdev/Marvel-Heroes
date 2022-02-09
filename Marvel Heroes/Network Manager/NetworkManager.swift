//
//  NetworkManager.swift
//  Marvel Heroes
//
//  Created by Илья Андреев on 08.02.2022.
//

import Foundation

public protocol NetworkManagerable: AnyObject {
    func fetchData(
        from url: URL,
        completed: @escaping (Result<Data, mhError>) -> Void
    )
}

public final class NetworkManager: NetworkManagerable {
    
    private var cache: [URL: Data] = [:]
    
    public init() {}
    
    public func fetchData(
        from url: URL,
        completed: @escaping (Result<Data, mhError>) -> Void
    ) {
        if let data = cache[url] {
            completed(.success(data))
            return
        }
        
        URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
            guard let self = self else { return }
            if error != nil {
                completed(.failure(.unableToComplete))
            }
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                      completed(.failure(.invalidResponse))
                      return
                  }
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            self.cache[url] = data
            completed(.success(data))
        }.resume()
    }
}
