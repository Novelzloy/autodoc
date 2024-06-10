import Foundation

protocol IFileManager: AnyObject {
    func fileExists(atPath path: String) -> Bool
    func createDirectrory(at url: URL) throws
}

extension FileManager: IFileManager {
    func createDirectrory(at url: URL) throws {
        try createDirectory(at: url, withIntermediateDirectories: true)
    }
}
