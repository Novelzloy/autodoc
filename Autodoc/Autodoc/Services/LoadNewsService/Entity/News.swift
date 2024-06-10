//
//  News.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import Foundation

struct NewsResponseServiceModel: Decodable {
    let news: [NewsServiceModel]
}

struct NewsServiceModel: Decodable {
    let id: Int
    let title: String
    let fullUrl: String
    let titleImageUrl: String?
}
