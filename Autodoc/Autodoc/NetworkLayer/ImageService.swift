//
//  ImageService.swift
//  Autodoc
//
//  Created by Роман Наумов on 30.10.2023.
//

import UIKit.UIImage

protocol ImageServiceProtocol: AnyObject {
    func fetchImage(fromUrl url: URL) async throws -> UIImage?
}

final class ImageService: ImageServiceProtocol {
    func fetchImage(fromUrl url: URL) async throws -> UIImage? {
        let fileCachePath =
        FileManager.default.temporaryDirectory.appendingPathComponent(url.lastPathComponent,isDirectory: false)
        
        if FileManager.default.fileExists(atPath: fileCachePath.path()) {
            let image = try UIImage(data: .init(contentsOf: fileCachePath))
            return image
        } else {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let response = response as? HTTPURLResponse else { throw NetworkError.notURLResponse}
            guard response.statusCode == 200 else { throw NetworkError.invalidResponse(response.statusCode) }
            
            guard let imageResult = UIImage(data: data) else { throw NetworkError.conversionError }

            try imageResult.jpegData(compressionQuality: 1.0)?.write(to: fileCachePath)
            return imageResult
        }
    }
}
