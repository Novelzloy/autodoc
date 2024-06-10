import UIKit.UIImage

protocol IImageResolver: AnyObject {
    func resolve() async throws -> UIImage
}
