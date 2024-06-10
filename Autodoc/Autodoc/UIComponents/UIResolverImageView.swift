import UIKit

final class UIResolverImageView: UIImageView {
    private var imageResolver: IImageResolver?
    private var task: Task<Void, Never>?

    func apply(imageResolver: IImageResolver) {
        resetImageResolver()
        self.imageResolver = imageResolver
        task = Task {
            guard let resolvedImage = try? await imageResolver.resolve(), !Task.isCancelled else { return }
            image = resolvedImage
        }
    }

    private func resetImageResolver() {
        task?.cancel()
        task = nil
        imageResolver = nil
        image = nil
    }
}
