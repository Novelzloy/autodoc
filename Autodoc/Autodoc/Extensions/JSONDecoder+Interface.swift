import Foundation

protocol IJSONDecoder: AnyObject {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

extension JSONDecoder: IJSONDecoder {}
