//
//  AppDelegate.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private lazy var applicationAssembly: IApplicationAssembly = ApplicationAssembly(applicationRouter: applicationRouter)
    private lazy var applicationRouter: IApplicationRouter = ApplicationRouter(window: window)

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        applicationRouter.setViewControllers([applicationAssembly.newsListAssembly.assemble()])
        return true
    }
}

