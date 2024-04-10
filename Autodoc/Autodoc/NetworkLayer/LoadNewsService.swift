//
//  LoadNews.swift
//  Autodoc
//
//  Created by Роман Наумов on 27.10.2023.
//

import Foundation

protocol LoadNewsServiceProtocol {
    func fetchDataNews(page: Int) async throws -> [News]
}

final class LoadNewsService: LoadNewsServiceProtocol {
    
    private let decoder: JSONDecoder
    private let entriesPerPage: Int
    
    init(decoder: JSONDecoder, entriesPerPage: Int) {
        self.decoder = decoder
        self.entriesPerPage = entriesPerPage
    }
    
    func fetchDataNews(page: Int) async throws -> [News] {
        guard let url = URL(string: String(format: NetworkConstants.apiURL, page, entriesPerPage)) else {throw NetworkError.invalidURL}
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse else {throw NetworkError.notURLResponse}
        guard response.statusCode == 200 else { throw NetworkError.invalidResponse(response.statusCode) }
        
        do {
            let result = try decoder.decode(AutodocModel.self, from: data)
            return result.news
        } catch {
            throw NetworkError.conversionError
        }
    }
}
