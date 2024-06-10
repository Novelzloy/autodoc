import UIKit.UIImage
import Foundation

enum URLImageResolverError: LocalizedError {
    case incorrectURL
    case imageLoadingFailure(Error)
}

final class URLImageResolver: IImageResolver {
    private let imageService: IImageService
    private let url: String?
    private let replaceErrorImage: UIImage?

    init(
        imageService: IImageService,
        url: String?,
        replaceErrorImage: UIImage? = nil
    ) {
        self.imageService = imageService
        self.url = url
        self.replaceErrorImage = replaceErrorImage
    }

    func resolve() async throws -> UIImage {
        do {
            guard let stringURL = url, let url = URL(string: stringURL) else { throw URLImageResolverError.incorrectURL }
            do {
                let image = try await imageService.loadImage(fromUrl: url)
                return image
            } catch {
                throw URLImageResolverError.imageLoadingFailure(error)
            }
        } catch {
            if let replaceErrorImage {
                return replaceErrorImage
            } else {
                throw error
            }
        }
    }
}
