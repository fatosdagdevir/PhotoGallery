import Foundation

protocol PhotoListing {
    func fetchPhotos() async throws -> [Photo]
}

final class PhotoListService: PhotoListing {
    private let photoProvider: PhotoProviding
    
    init(photoProvider: PhotoProviding = PhotoProvider()) {
        self.photoProvider = photoProvider
    }
    
    func fetchPhotos() async throws -> [Photo] {
        try await photoProvider.fetchPhotoGallery()
    }
}
