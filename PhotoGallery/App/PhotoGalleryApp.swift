import SwiftUI

@main
struct PhotoGalleryApp: App {
    @StateObject private var navigator = Navigator()
    
    var body: some Scene {
        WindowGroup {
           AppCoordinator(navigator: navigator)
        }
    }
}
