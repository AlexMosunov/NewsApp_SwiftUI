//
//  Webservice.swift
//  NewsApp-SwiftUI
//
//  Created by Alex Mosunov on 15.03.2022.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidData
    case decodingError
}

class Webservice {
    
    
    func fetchSourcesAsync(url: URL?) async throws -> [NewsSource] {
        guard let url = url else { return [] }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data)
        return newsSourceResponse?.sources ?? []
        
    }

    
    func fetchNews(by sourceId: String, url: URL?, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        
        guard let url = url else {
            completion(.failure(.badUrl))
            return
        }
            
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.invalidData))
                return
            }
            
            let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data)
            completion(.success(newsArticleResponse?.articles ?? []))
            
        }.resume()
        
    }
    
}
