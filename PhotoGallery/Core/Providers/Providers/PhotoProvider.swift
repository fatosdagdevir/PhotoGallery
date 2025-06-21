import Foundation

protocol PhotoProviding {
    func fetchPhotoGallery() async throws -> [Photo]
}

final class PhotoProvider: PhotoProviding {
    private let network: Networking
    init(network: Networking = Network()) {
        self.network = network
    }
    
    func fetchPhotoGallery() async throws -> [Photo] {
        let endpoint = PhotoGalleryEndpoint()
        let request = PhotoGalleryRequest(endpoint: endpoint)
        let response = try await network.send(request: request)
        return response.map { $0.mapped }
    }
}

private struct PhotoGalleryEndpoint: EndpointProtocol {
    let base = AppConstants.API.baseURL
    let path = "photos"
}

private struct PhotoGalleryRequest: RequestProtocol {
    typealias Response = [PhotoDTO]
    let endpoint: EndpointProtocol
    let method: HTTP.Method = .get
}
