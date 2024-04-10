//
//  NewsServices.swift
//  Autodoc
//
//  Created by Роман Наумов on 06.11.2023.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchData(url: String) async throws -> Data
}


final class News: NewsServiceProtocol {
    
}
