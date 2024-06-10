import Foundation

protocol IServicesAssembly: AnyObject {
    var imageService: IImageService { get }
}

final class ServicesAssembly: IServicesAssembly {
    private lazy var commonPathURLProvider: ICommonPathURLProvider = CommonPathURLProvider(
        directoryPathFinder: FileManager.default
    )

    private lazy var dataFileCacheService: IDataFileCacheService = DataFileCacheService(
        fileManager: FileManager.default
    )

    private lazy var imageDataConverter: IImageDataConverter = ImageDataConverter()

    private lazy var imageFileCacheService: IImageFileCacheService = ImageCacheService(
        dataFileCacheService: dataFileCacheService,
        imageDataConverter: imageDataConverter
    )

    private lazy var consoleLogger: ILogger = ConsoleLogger()

    private(set) lazy var imageService: IImageService = ImageService(
        commonPathURLProvider: commonPathURLProvider,
        imageFileCacheService: imageFileCacheService,
        imageDataConverter: imageDataConverter,
        urlSession: URLSession.shared,
        logger: consoleLogger
    )
}
