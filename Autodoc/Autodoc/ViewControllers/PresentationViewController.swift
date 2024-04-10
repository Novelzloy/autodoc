//
//  PresentationViewController.swift
//  Autodoc
//
//  Created by Роман Наумов on 06.12.2023.
//

import UIKit
import WebKit

final class PresentationViewController: UIViewController, WKNavigationDelegate {
    private let news: News
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    private lazy var webView: WKWebView = {
        let web = WKWebView()
        web.translatesAutoresizingMaskIntoConstraints = false
        return web
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        indicator.color = .red
        return indicator
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        webView.navigationDelegate = self
        setupConstraints()
        loadFullNews()
    }
    
    private func loadFullNews() {
        if let url = URL(string: news.fullUrl) {
            let getUrlRequest = URLRequest(url: url)
            webView.load(getUrlRequest)
        } else {
            let alert = UIAlertController(title: nil,
                                          message: "Failed to follow the link",
                                          preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "Go back", style: .default) {_ in
                self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAlert)
            self.present(alert, animated: true)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    private func setupConstraints() {
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

