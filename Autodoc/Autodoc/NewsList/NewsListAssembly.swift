import UIKit.UIViewController

protocol INewsListAssembly: AnyObject {
    func assemble() -> UIViewController
}

final class NewsListAssembly: INewsListAssembly {
    private let applicationRouter: IApplicationRouter
    private let servicesAssembly: IServicesAssembly
    private let newsDetailsAssembly: INewsDetailsAssembly

    init(
        applicationRouter: IApplicationRouter,
        servicesAssembly: IServicesAssembly,
        newsDetailsAssembly: INewsDetailsAssembly
    ) {
        self.applicationRouter = applicationRouter
        self.servicesAssembly = servicesAssembly
        self.newsDetailsAssembly = newsDetailsAssembly
    }

    func assemble() -> UIViewController {
        let loadNewsService = LoadNewsService(
            urlSession: URLSession.shared,
            jsonDecoder: JSONDecoder()
        )
        let newsListInfoProvider = NewsListInfoProvider(
            loadNewsService: loadNewsService,
            entriesPerPage: 15
        )
        let router = NewsListRouter(
            newsDetailsAssembly: newsDetailsAssembly,
            applicationRouter: applicationRouter
        )
        let presenter = NewsListPresenter(
            router: router,
            newsListInfoProvider: newsListInfoProvider,
            imageService: servicesAssembly.imageService
        )
        newsListInfoProvider.output = presenter
        let viewController = NewsListViewController(presenter: presenter)
        presenter.view = viewController

        return viewController
    }
}
