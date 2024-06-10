import UIKit.UIImage

enum ImageDataConverterError: LocalizedError {
    case conversionImageToDataFailure(ImageDataConversionType)
    case conversionDataToImageFailure
}

enum ImageDataConversionType {
    case png
    case jpeg(quality: CGFloat)
    case heic
}

protocol IImageDataConverter: AnyObject {
    func convertImage(_ image: UIImage, conversionType: ImageDataConversionType) async throws -> Data
    func convertData(_ data: Data) async throws -> UIImage
}

final class ImageDataConverter: IImageDataConverter {
    func convertImage(_ image: UIImage, conversionType: ImageDataConversionType) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            let data: Data?
            switch conversionType {
            case .png: data = image.pngData()
            case let .jpeg(quality): data = image.jpegData(compressionQuality: quality)
            case .heic: data = image.heicData()
            }
            if let data {
                continuation.resume(returning: data)
            } else {
                continuation.resume(throwing: ImageDataConverterError.conversionImageToDataFailure(conversionType))
            }
        }
    }

    func convertData(_ data: Data) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            if let image = UIImage(data: data) {
                continuation.resume(returning: image)
            } else {
                continuation.resume(throwing: ImageDataConverterError.conversionDataToImageFailure)
            }
        }
    }
}
