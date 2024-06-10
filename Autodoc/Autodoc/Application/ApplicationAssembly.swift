import Foundation

protocol IApplicationAssembly: AnyObject {
    var newsListAssembly: INewsListAssembly { get }
}

final class ApplicationAssembly: IApplicationAssembly {
    private let applicationRouter: IApplicationRouter

    init(applicationRouter: IApplicationRouter) {
        self.applicationRouter = applicationRouter
    }

    private(set) lazy var newsListAssembly: INewsListAssembly = NewsListAssembly(
        applicationRouter: applicationRouter,
        servicesAssembly: servicesAssembly,
        newsDetailsAssembly: newsDetailsAssembly
    )

    private(set) lazy var newsDetailsAssembly: INewsDetailsAssembly = NewsDetailsAssembly()

    private lazy var servicesAssembly: IServicesAssembly = ServicesAssembly()
}
