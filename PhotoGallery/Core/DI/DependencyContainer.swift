import Foundation
import Networking

@MainActor
final class DependencyContainer {
    let navigator: Navigator
    let network: Networking
    let photoProvider: PhotoProviding
    let photoListService: PhotoListing
    let photoDetailService: PhotoDetailing
    
    init() {
        self.navigator = Navigator()
        self.network = Network(timeoutInterval: AppConstants.API.timeout)
        self.photoProvider = PhotoProvider(network: network)
        self.photoListService = PhotoListService(photoProvider: photoProvider)
        self.photoDetailService = PhotoDetailService(photoProvider: photoProvider)
    }
}
