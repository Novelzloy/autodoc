import Foundation

protocol INewsDetailsViewControllerOutput: AnyObject {
    func viewDidLoad()
}

final class NewsDetailsPresenter: INewsDetailsViewControllerOutput {
    private let url: URL
    weak var view: INewsDetailsViewControllerInput?

    init(url: URL) {
        self.url = url
    }

    func viewDidLoad() {
        view?.openWebsite(for: URLRequest(url: url))
    }
}
