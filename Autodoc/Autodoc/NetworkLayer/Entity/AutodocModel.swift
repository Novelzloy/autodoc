//
//  AutodocModel.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import Foundation

struct AutodocModel: Codable, Hashable {
    let news: [News]
}

struct News: Codable, Hashable {
    let id: Int
    let title: String
    let fullUrl: String
    let titleImageUrl: String?
}
