//
//  NewsListInfoProvider.swift
//  Autodoc
//
//  Created by Роман Наумов on 13.11.2023.
//

import Foundation

protocol INewsListInfoProviderOutput: AnyObject {
    func newsListUpdated(_ newsList: [NewsProviderModel])
}

protocol INewsListInfoProvider: AnyObject {
    func loadNextNewsPage() async throws
    func getCachedNews(with id: UUID) -> NewsProviderModel?
}

struct NewsProviderModel {
    let id: UUID
    let title: String
    let fullURL: String
    let imageURL: String?
}

final class NewsListInfoProvider: INewsListInfoProvider {
    weak var output: INewsListInfoProviderOutput?

    private let loadNewsService: ILoadNewsService
    private let entriesPerPage: Int
    
    private var newsContainer = [NewsProviderModel]()

    private var isLastPageLoaded = false
    private var isDataLoading = false
    
    init(
        loadNewsService: ILoadNewsService,
        entriesPerPage: Int
    ){
        self.loadNewsService = loadNewsService
        self.entriesPerPage = entriesPerPage
    }

    func getLoadedNews(withId id: UUID) -> NewsProviderModel? {
        newsContainer.first { $0.id == id }
    }

    func loadNextNewsPage() async throws {
        guard !isDataLoading, !isLastPageLoaded else { return }

        isDataLoading = true

        do {
            let downloadedNews = try await loadNewsService.downloadNews(atPage: newsContainer.count / entriesPerPage + 1, entriesPerPage: entriesPerPage)
            newsContainer.append(contentsOf: downloadedNews.map { NewsProviderModel(from: $0) })
            if downloadedNews.count < entriesPerPage {
                isLastPageLoaded = true
            }
            isDataLoading = false
            output?.newsListUpdated(newsContainer)
        } catch {
            isDataLoading = false
            throw error
        }
    }

    func getCachedNews(with id: UUID) -> NewsProviderModel? {
        newsContainer.first { $0.id == id }
    }
}

extension NewsProviderModel {
    init(from serviceModel: NewsServiceModel) {
        self.init(
            id: .init(),
            title: serviceModel.title,
            fullURL: serviceModel.fullUrl,
            imageURL: serviceModel.titleImageUrl
        )
    }
}
