//
//  NewsListPresenter.swift
//  Autodoc
//
//  Created by Роман Наумов on 15.04.2024.
//

import UIKit.UIImage

protocol INewsListViewControllerOutput: AnyObject {
    func viewDidLoad()
    func scrollReachedBottom()
    func newsSelected(_ news: NewsPresentationModel)
}

final class NewsListPresenter: INewsListViewControllerOutput {
    weak var view: INewsListViewControllerInput?

    private let router: INewsListRouter
    private let newsListInfoProvider: INewsListInfoProvider
    private let imageService: IImageService

    init(
        router: INewsListRouter,
        newsListInfoProvider: INewsListInfoProvider,
        imageService: IImageService
    ) {
        self.router = router
        self.newsListInfoProvider = newsListInfoProvider
        self.imageService = imageService
    }

    func viewDidLoad() {
        loadNextPage()
    }

    func scrollReachedBottom() {
        loadNextPage()
    }

    func newsSelected(_ news: NewsPresentationModel) {
        guard let news = newsListInfoProvider.getCachedNews(with: news.id), let detailsURL = URL(string: news.fullURL)  else { return }
        router.openNewsDetails(forURL: detailsURL)
    }

    private func loadNextPage() {
        Task(priority: .userInitiated) {
            try await newsListInfoProvider.loadNextNewsPage()
        }
    }
}

extension NewsListPresenter: INewsListInfoProviderOutput {
    func newsListUpdated(_ newsList: [NewsProviderModel]) {
        Task {
            await MainActor.run {
                let presentationModels = newsList.map {
                    NewsPresentationModel(
                        id: $0.id,
                        title: $0.title,
                        imageResolver: URLImageResolver(imageService: imageService, url: $0.imageURL, replaceErrorImage: .noImage))
                }
                view?.showNewsList(presentationModels)
            }
        }
    }
}
