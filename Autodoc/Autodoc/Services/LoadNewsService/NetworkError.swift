//
//  NetworkError.swift
//  Autodoc
//
//  Created by Роман Наумов on 26.10.2023.
//

import Foundation

enum NetworkError: Error {
    case decodingError
    case notURLResponse
    case invalidResponse(_ statusCode: Int)
    case conversionError
    case responceError
    case invalidURL
    case noData
}
