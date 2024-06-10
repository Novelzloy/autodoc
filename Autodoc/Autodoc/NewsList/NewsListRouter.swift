import Foundation

protocol INewsListRouter: AnyObject {
    func openNewsDetails(forURL url: URL)
}

final class NewsListRouter: INewsListRouter {
    private let newsDetailsAssembly: INewsDetailsAssembly
    private let applicationRouter: IApplicationRouter

    init(newsDetailsAssembly: INewsDetailsAssembly, applicationRouter: IApplicationRouter) {
        self.newsDetailsAssembly = newsDetailsAssembly
        self.applicationRouter = applicationRouter
    }

    func openNewsDetails(forURL url: URL) {
        applicationRouter.pushViewController(newsDetailsAssembly.assemble(forURL: url))
    }
}
