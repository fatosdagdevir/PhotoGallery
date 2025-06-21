import Foundation

@MainActor
final class DependencyContainer {
    let navigator: Navigator
    let network: Networking
    let photoProvider: PhotoProviding
    let photoListService: PhotoListing
    
    init() {
        self.navigator = Navigator()
        self.network = Network()
        self.photoProvider = PhotoProvider(network: network)
        self.photoListService = PhotoListService(photoProvider: photoProvider)
    }
}
