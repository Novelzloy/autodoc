//
//  NewsCell.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    
    private lazy var newsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#6F30B9")
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var imageNews: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var titleNews: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = .black
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageNews.image = nil
        titleNews.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: News) {
        titleNews.text = model.title
        imageNews.image = UIImage(named: model.titleImageUrl ?? "")
    }
    
    private func setupConstraints() {
        contentView.addSubview(newsView)
        newsView.addSubview(imageNews)
        newsView.addSubview(titleNews)
        NSLayoutConstraint.activate([
            newsView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            newsView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            newsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageNews.topAnchor.constraint(equalTo: newsView.topAnchor, constant: 8),
            imageNews.leadingAnchor.constraint(equalTo: newsView.leadingAnchor, constant: 8),
            imageNews.trailingAnchor.constraint(equalTo: newsView.trailingAnchor, constant: -8),
            imageNews.heightAnchor.constraint(equalToConstant: 140),
            titleNews.topAnchor.constraint(equalTo: imageNews.bottomAnchor, constant: 16),
            titleNews.leadingAnchor.constraint(equalTo: newsView.leadingAnchor, constant: 5),
            titleNews.trailingAnchor.constraint(equalTo: newsView.trailingAnchor,constant: -5),
            titleNews.bottomAnchor.constraint(equalTo: newsView.bottomAnchor, constant: -5)
        ])
    }
}
