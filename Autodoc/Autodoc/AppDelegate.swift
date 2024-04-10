//
//  AppDelegate.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private lazy var imageService: ImageService = ImageService()
    private lazy var loadNewsService: LoadNewsServiceProtocol = 
    LoadNewsService(decoder: .init(),
                    entriesPerPage: NetworkConstants.entriesPerPage)
    private lazy var newsDataProvider: NewsDataProviderProtocol = 
    NewsDataProvider(loadNews: loadNewsService,
                     entriesPerPage: NetworkConstants.entriesPerPage)

    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let mainVC = MainViewController(newsDataProvider: newsDataProvider,
                                        imageService: imageService,
                                        loadNewsService: loadNewsService)
        window?.rootViewController = UINavigationController(rootViewController: mainVC)
        window?.makeKeyAndVisible()
        return true
    }
}

