import UIKit.UIImage

enum ImageCacheServiceError: LocalizedError {
    case createImageFromLoadedDataFailure
}

protocol IImageFileCacheService: AnyObject {
    func saveImage(_ image: UIImage, inType type: ImageDataConversionType, toURL url: URL) async throws
    func image(fromURL url: URL) async throws -> UIImage
}

final class ImageCacheService: IImageFileCacheService {
    private let dataFileCacheService: IDataFileCacheService
    private let imageDataConverter: IImageDataConverter

    init(
        dataFileCacheService: IDataFileCacheService,
        imageDataConverter: IImageDataConverter
    ) {
        self.dataFileCacheService = dataFileCacheService
        self.imageDataConverter = imageDataConverter
    }

    func saveImage(_ image: UIImage, inType type: ImageDataConversionType, toURL url: URL) async throws {
        try await dataFileCacheService.saveData(
            try await imageDataConverter.convertImage(image, conversionType: type),
            toURL: url
        )
    }

    func image(fromURL url: URL) async throws -> UIImage {
        try await imageDataConverter.convertData(try await dataFileCacheService.loadData(fromURL: url))
    }
}
