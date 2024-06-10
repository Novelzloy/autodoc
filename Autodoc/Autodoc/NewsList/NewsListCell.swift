//
//  NewsListCell.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import UIKit

final class NewsListCell: UICollectionViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(hex: "#6F30B9")
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var newsImageView: UIResolverImageView = {
        let image = UIResolverImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 5
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var newsLabel: UILabel = {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: NewsPresentationModel) {
        newsLabel.text = model.title
        newsImageView.apply(imageResolver: model.imageResolver)
    }
    
    private func setupConstraints() {
        contentView.addSubview(containerView)
        containerView.addSubview(newsImageView)
        containerView.addSubview(newsLabel)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            newsImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            newsImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            newsImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            newsImageView.heightAnchor.constraint(equalToConstant: 140),
            newsLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16),
            newsLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 5),
            newsLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -5),
            newsLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
    }
}
