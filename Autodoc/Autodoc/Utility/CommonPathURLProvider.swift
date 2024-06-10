import Foundation

protocol ICommonPathURLProvider: AnyObject {
    var cachesURL: URL { get throws }
    var imageCaches: URL { get throws }
}

final class CommonPathURLProvider: ICommonPathURLProvider {
    private let directoryPathFinder: IDirectoryPathFinder

    init(directoryPathFinder: IDirectoryPathFinder) {
        self.directoryPathFinder = directoryPathFinder
    }

    var cachesURL: URL {
        get throws { try directoryPathFinder.findDirectoryURL(for: .caches) }
    }

    var imageCaches: URL {
        get throws { try cachesURL.appendingPathComponent("images") }
    }
}
