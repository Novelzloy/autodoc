import Foundation

enum DataFileCacheServiceError: LocalizedError {
    case noFileAtURL
}

protocol IDataFileCacheService: AnyObject {
    func saveData(_ data: Data, toURL url: URL) async throws
    func loadData(fromURL url: URL) async throws -> Data
}

final class DataFileCacheService: IDataFileCacheService {
    private let fileManager: IFileManager

    init(fileManager: IFileManager) {
        self.fileManager = fileManager
    }

    func saveData(_ data: Data, toURL url: URL) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let saveFolderURL = url.deletingLastPathComponent()
                if !fileManager.fileExists(atPath: saveFolderURL.path()) {
                    try fileManager.createDirectrory(at: saveFolderURL)
                }
                try data.write(to: url)
                continuation.resume()
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    func loadData(fromURL url: URL) async throws -> Data {
        try await withCheckedThrowingContinuation { continuation in
            do {
                guard fileManager.fileExists(atPath: url.path()) else { throw DataFileCacheServiceError.noFileAtURL }
                let data = try Data(contentsOf: url)
                continuation.resume(returning: data)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
}
