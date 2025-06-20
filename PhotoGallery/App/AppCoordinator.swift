import SwiftUI

struct AppCoordinator: View {
    @ObservedObject var navigator: Navigator
    
    var body: some View {
        NavigationStack(path: $navigator.path) {
            PhotoListCoordinator(navigator: navigator)
        }
    }
}
