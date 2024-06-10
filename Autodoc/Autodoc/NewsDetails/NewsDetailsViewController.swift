//
//  NewsDetailsViewController.swift
//  Autodoc
//
//  Created by Роман Наумов on 06.12.2023.
//

import UIKit
import WebKit

protocol INewsDetailsViewControllerInput: AnyObject {
    func openWebsite(for urlRequest: URLRequest)
}

final class NewsDetailsViewController: UIViewController {
    private let presenter: INewsDetailsViewControllerOutput

    init(presenter: INewsDetailsViewControllerOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .red
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView.navigationDelegate = self
        setupSubviews()
        presenter.viewDidLoad()
    }
    
    private func setupSubviews() {
        view.addSubview(webView)
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

extension NewsDetailsViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
}

extension NewsDetailsViewController: INewsDetailsViewControllerInput {
    func openWebsite(for urlRequest: URLRequest) {
        activityIndicator.startAnimating()
        webView.load(urlRequest)
    }
}
