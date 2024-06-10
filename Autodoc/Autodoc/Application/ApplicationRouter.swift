import Foundation
import UIKit.UIViewController

protocol IApplicationRouter: AnyObject {
    func setViewControllers(_ viewControllers: [UIViewController])
    func pushViewController(_ viewController: UIViewController)
    func popViewController()
}

final class ApplicationRouter: IApplicationRouter {
    private let window: UIWindow?
    private let navigationController: UINavigationController

    init(window: UIWindow?) {
        self.window = window
        self.navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func pushViewController(_ viewController: UIViewController) {
        navigationController.pushViewController(viewController, animated: true)
    }

    func popViewController() {
        navigationController.popViewController(animated: true)
    }

    func setViewControllers(_ viewControllers: [UIViewController]) {
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}
