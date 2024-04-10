//
//  MainViewController.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import UIKit
import Combine

enum Section: Int, CaseIterable {
    case grid
}

final class MainViewController: UIViewController {
    private let newsDataProvider: NewsDataProviderProtocol
    private let imageService: ImageServiceProtocol
    private let loadNewsService: LoadNewsServiceProtocol
    private let cancellable = AnyCancellable(<#() -> Void#>)
    
    init(newsDataProvider: NewsDataProviderProtocol,
         imageService: ImageServiceProtocol,
         loadNewsService: LoadNewsServiceProtocol) {
        self.newsDataProvider = newsDataProvider
        self.imageService = imageService
        self.loadNewsService = loadNewsService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, News> =
        .init(collectionView: collectionView) { collectionView, indexPath, items in
            let cell = collectionView.dequeueCell(of: NewsCell.self, for: indexPath)
            cell.configure(model: items)
            if let imageService = items.titleImageUrl.flatMap({URL(string: $0)}) {
                Task {
                    cell.imageNews.image = try await self.imageService.fetchImage(fromUrl: imageService)
                }
            }
            return cell
        }
    
    private lazy var layout: UICollectionViewCompositionalLayout =
        .init(sectionProvider: {sectionIndex, environment in
            guard let sectionType = Section(rawValue: sectionIndex) else {return nil}
            switch sectionType {
                case .grid:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250)), repeatingSubitem: item, count: 2)
                    group.interItemSpacing = .fixed(8)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
                    section.interGroupSpacing = 8
                    return section
                }
            }
        )

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.registerCell(of: NewsCell.self)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewAppearance()
        newsDataProvider.delegate = self
        setupSubViews()
        Task {
            try await newsDataProvider.loadNextPage()
        }
    }
    
    private func setupViewAppearance() {
        navigationItem.title = "Autodoc News"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(ciColor: .black)
        ]
    }
    // MARK: - setup dataSource
    private func setupDataSourceSnapshot(with news: [News]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, News>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(news, toSection: .grid)
        dataSource.apply(snapshot)
    }
    
    private func setupSubViews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension MainViewController: NewsDataProviderDelegate {
    func newsUpdated(_ news: [News]) {
        setupDataSourceSnapshot(with: news)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if dataSource.snapshot().numberOfItems - 1 == indexPath.row {
            Task {
               try await newsDataProvider.loadNextPage()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedNews = dataSource.itemIdentifier(for: indexPath) {
            let vc = PresentationViewController(news: selectedNews)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
