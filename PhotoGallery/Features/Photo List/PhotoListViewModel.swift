import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    private let navigator: Navigator

    init(navigator: Navigator) {
        self.navigator = navigator
    }
}

