import Foundation
import UIKit.UIViewController

protocol INewsDetailsAssembly: AnyObject {
    func assemble(forURL url: URL) -> UIViewController
}

final class NewsDetailsAssembly: INewsDetailsAssembly {
    func assemble(forURL url: URL) -> UIViewController {
        let presenter = NewsDetailsPresenter(url: url)
        let viewController = NewsDetailsViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
