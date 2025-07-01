import Foundation
import Networking

protocol PhotoProviding {
    func fetchPhotoGallery() async throws -> [Photo]
    func fetchPhotoDetail(with id: Int) async throws -> PhotoDetail
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
    
    func fetchPhotoDetail(with id: Int) async throws -> PhotoDetail {
        let endpoint = PhotoDetailEndpoint(id: id)
        let request = PhotoDetailRequest(endpoint: endpoint)
        let response = try await network.send(request: request)
        return response.mapped
    }
}

// MARK: - Photo Gallery
private struct PhotoGalleryEndpoint: EndpointProtocol {
    let base = AppConstants.API.baseURL
    let path = "/photos"

    
    var queryParameters: [String : String]?
}

private struct PhotoGalleryRequest: RequestProtocol {
    typealias Response = [PhotoDTO]
    let endpoint: any EndpointProtocol
    let method: HTTP.Method = .GET
}

// MARK: - Photo Detail
private struct PhotoDetailEndpoint: EndpointProtocol {
    let base = AppConstants.API.baseURL
    let path: String
    
    var queryParameters: [String : String]?
    
    init(id: Int) {
        self.path = "/photos/\(id)"
    }
}

private struct PhotoDetailRequest: RequestProtocol {
    typealias Response = PhotoDetailDTO
    let endpoint: any EndpointProtocol
    let method: HTTP.Method = .GET
}
