//
//  ImageService.swift
//  Autodoc
//
//  Created by Роман Наумов on 30.10.2023.
//

import UIKit.UIImage

protocol IImageService: AnyObject {
    func loadImage(fromUrl url: URL) async throws -> UIImage
}

final class ImageService: IImageService {
    private let commonPathURLProvider: ICommonPathURLProvider
    private let imageFileCacheService: IImageFileCacheService
    private let imageDataConverter: IImageDataConverter
    private let urlSession: IURLSession
    private let logger: ILogger

    init(
        commonPathURLProvider: ICommonPathURLProvider,
        imageFileCacheService: IImageFileCacheService,
        imageDataConverter: IImageDataConverter,
        urlSession: IURLSession,
        logger: ILogger
    ) {
        self.commonPathURLProvider = commonPathURLProvider
        self.imageFileCacheService = imageFileCacheService
        self.imageDataConverter = imageDataConverter
        self.urlSession = urlSession
        self.logger = logger
    }

    func loadImage(fromUrl url: URL) async throws -> UIImage {
        let cacheImageURL = makeCacheURL(fromImageURL: url)

        if let cacheImageURL {
            do {
                let cachedImage = try await imageFileCacheService.image(fromURL: cacheImageURL)
                logger.logInfo("Image with \(url) found in cache")
                return cachedImage
            } catch DataFileCacheServiceError.noFileAtURL {
                logger.logInfo("Image with \(url) not found in cache")
            } catch {
                logger.logError(error)
            }
        }

        try Task.checkCancellation()
        let image = try await loadImageFromURL(url)

        logger.logInfo("Image with \(url) downloaded successfully")

        if let cacheImageURL {
            Task(priority: .background) {
                do {
                    logger.logInfo("Caching image with \(url)...")
                    try await imageFileCacheService.saveImage(image, inType: .jpeg(quality: 1), toURL: cacheImageURL)
                    logger.logInfo("Image with \(url) cached successfully")
                } catch {
                    logger.logError(error)
                }
            }
        }
        return image
    }

    private func loadImageFromURL(_ url: URL) async throws -> UIImage {
        logger.logInfo("Downloading image from URL: \(url)")

        let (data, _) = try await urlSession.data(from: url)
        return try await imageDataConverter.convertData(data)
    }

    private func makeCacheURL(fromImageURL url: URL) -> URL? {
        do {
            return try commonPathURLProvider.imageCaches.appendingPathComponent(url.absoluteString)
        } catch {
            logger.logError(error)
        }
        return nil
    }
}
