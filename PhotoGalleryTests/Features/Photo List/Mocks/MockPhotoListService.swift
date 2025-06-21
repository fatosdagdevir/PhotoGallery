import Foundation
@testable import PhotoGallery

final class MockPhotoListService: PhotoListing {
    var fetchPhotosResult: Result<[Photo], Error> = .success([])
    private(set) var fetchPhotosCallCount = 0
    
    func fetchPhotos() async throws -> [Photo] {
        fetchPhotosCallCount += 1
        
        switch fetchPhotosResult {
        case .success(let photos):
            return photos
        case .failure(let error):
            throw error
        }
    }
    
    func reset() {
        fetchPhotosCallCount = 0
        fetchPhotosResult = .success([])
    }
}
