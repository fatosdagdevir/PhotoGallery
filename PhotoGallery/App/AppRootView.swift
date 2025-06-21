import SwiftUI

struct AppRootView: View {
    @StateObject private var navigator: Navigator
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
        self._navigator = StateObject(wrappedValue: container.navigator)
    }
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            PhotoListCoordinator(
                navigator: navigator,
                photoListService: container.photoListService
            )
        }
    }
}
