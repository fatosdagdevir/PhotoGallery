import SwiftUI

@main
struct PhotoGalleryApp: App {
    private let container: DependencyContainer

    init() {
        self.container = DependencyContainer()
    }
    
    var body: some Scene {
        WindowGroup {
            AppRootView(container: container)
        }
    }
}
