import Foundation

protocol PhotoDetailing {
    func fetchPhotoDetail(id: Int) async throws -> PhotoDetail
}

final class PhotoDetailService: PhotoDetailing {
    private let photoProvider: PhotoProviding
    
    init(photoProvider: PhotoProviding) {
        self.photoProvider = photoProvider
    }
    
    func fetchPhotoDetail(id: Int) async throws -> PhotoDetail {
        try await photoProvider.fetchPhotoDetail(with: id)
    }
}
