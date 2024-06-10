//
//  NewsListViewController.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import UIKit

protocol INewsListViewControllerInput: AnyObject {
    func showNewsList(_ newsList: [NewsPresentationModel])
}

struct NewsPresentationModel: Hashable, Equatable {
    let id: UUID
    let title: String
    let imageResolver: IImageResolver

    static func == (lhs: NewsPresentationModel, rhs: NewsPresentationModel) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class NewsListViewController: UIViewController {
    private let presenter: INewsListViewControllerOutput

    init(presenter: INewsListViewControllerOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collection.registerCell(of: NewsListCell.self)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        return collection
    }()

    private lazy var dataSource: UICollectionViewDiffableDataSource<Int, NewsPresentationModel> =
        .init(collectionView: collectionView) { [weak self] collectionView, indexPath, newsModel in
            let cell = collectionView.dequeueCell(of: NewsListCell.self, for: indexPath)
            cell.configure(model: newsModel)
            return cell
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewAppearance()
        setupSubviews()
        presenter.viewDidLoad()
    }
    
    private func setupViewAppearance() {
        navigationItem.title = "Autodoc News"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor(ciColor: .black)
        ]
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(250)), repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 10, leading: 10, bottom: 10, trailing: 10)
        section.interGroupSpacing = 8
        return .init(section: section)
    }
}

extension NewsListViewController: INewsListViewControllerInput {
    func showNewsList(_ newsList: [NewsPresentationModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, NewsPresentationModel>()
        snapshot.appendSections([.zero])
        snapshot.appendItems(newsList)
        dataSource.apply(snapshot)
    }
}

extension NewsListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard dataSource.snapshot().numberOfItems - 1 == indexPath.row else { return }
        presenter.scrollReachedBottom()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedNews = dataSource.itemIdentifier(for: indexPath) else { return }
        presenter.newsSelected(selectedNews)
    }
}
