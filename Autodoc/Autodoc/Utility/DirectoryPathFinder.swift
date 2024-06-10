import Foundation

enum DirectoryPathFinderError: LocalizedError {
    case directoryNotFound
}

enum DirectorySearchPath {
    case caches
}

protocol IDirectoryPathFinder: AnyObject {
    func findDirectoryURL(for searchPath: DirectorySearchPath) throws -> URL
}

extension FileManager: IDirectoryPathFinder {
    func findDirectoryURL(for searchPath: DirectorySearchPath) throws -> URL {
        if let directoryURL = urls(for: searchPath.fileManagerSearchPath, in: .userDomainMask).first {
            return directoryURL
        } else {
            throw DirectoryPathFinderError.directoryNotFound
        }
    }
}

private extension DirectorySearchPath {
    var fileManagerSearchPath: FileManager.SearchPathDirectory {
        switch self {
        case .caches: return .cachesDirectory
        }
    }
}
