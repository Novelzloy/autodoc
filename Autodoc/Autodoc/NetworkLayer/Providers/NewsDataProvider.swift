//
//  NewsDataProvider.swift
//  Autodoc
//
//  Created by Роман Наумов on 13.11.2023.
//

import Foundation
import UIKit

protocol NewsDataProviderDelegate: AnyObject {
    func newsUpdated(_ news: [News])
}

protocol NewsDataProviderProtocol: AnyObject {
    var delegate: NewsDataProviderDelegate? { get set }
    func loadNextPage() async throws
}

final class NewsDataProvider: NewsDataProviderProtocol {
    weak var delegate : NewsDataProviderDelegate?
    
    private let loadNews: LoadNewsServiceProtocol
    private let entriesPerPage: Int
    
    private var loadedNews = [News]()
    
    private var isLastPageLoader = false
    private var isDataLoading = false
    
    init(loadNews: LoadNewsServiceProtocol, entriesPerPage: Int){
        self.loadNews = loadNews
        self.entriesPerPage = entriesPerPage
    }
    
    func loadNextPage() async throws {
        guard !isDataLoading, !isLastPageLoader else {return}
        
        do {
            isDataLoading = true
            let news = try await loadNews.fetchDataNews(page: loadedNews.count / entriesPerPage + 1)
            loadedNews.append(contentsOf: news)
            if news.count < entriesPerPage {
                isLastPageLoader = true
            }
            isDataLoading = false
            delegate?.newsUpdated(loadedNews)
        } catch {
            isDataLoading = false
            throw error
        }
    }
}


