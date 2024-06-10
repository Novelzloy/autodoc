//
//  LoadNewsService.swift
//  Autodoc
//
//  Created by Роман Наумов on 27.10.2023.
//

import Foundation

enum LoadNewsServiceError: LocalizedError {
    case invalidURL
}

private enum LoadNewsServiceConstants {
    static let apiURL = "https://webapi.autodoc.ru/api/news/%i/%i"
}

protocol ILoadNewsService: AnyObject {
    func downloadNews(atPage page: Int, entriesPerPage: Int) async throws -> [NewsServiceModel]
}

final class LoadNewsService: ILoadNewsService {
    private let urlSession: IURLSession
    private let jsonDecoder: IJSONDecoder
    
    init(
        urlSession: IURLSession,
        jsonDecoder: IJSONDecoder
    ) {
        self.urlSession = urlSession
        self.jsonDecoder = jsonDecoder
    }

    func downloadNews(atPage page: Int, entriesPerPage: Int) async throws -> [NewsServiceModel] {
        guard let downloadURL = URL(string: String(format: LoadNewsServiceConstants.apiURL, page, entriesPerPage)) else {
            throw LoadNewsServiceError.invalidURL
        }

        let (data, _) = try await urlSession.data(from: downloadURL)

        do {
            let result = try jsonDecoder.decode(NewsResponseServiceModel.self, from: data)
            return result.news
        } catch {
            throw error
        }
    }
}
