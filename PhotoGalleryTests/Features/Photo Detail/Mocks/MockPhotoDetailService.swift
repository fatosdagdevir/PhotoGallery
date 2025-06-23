import Foundation
import Networking
@testable import PhotoGallery

// MARK: - Mock PhotoDetailService
final class MockPhotoDetailService: PhotoDetailing {
    var fetchPhotoDetailCallCount = 0
    var lastFetchPhotoID: Int?
    var fetchPhotoDetailResult: Result<PhotoDetail, Error> = .failure(NetworkError.offline)
    
    func fetchPhotoDetail(id: Int) async throws -> PhotoDetail {
        fetchPhotoDetailCallCount += 1
        lastFetchPhotoID = id
        
        switch fetchPhotoDetailResult {
        case .success(let photo):
            return photo
        case .failure(let error):
            throw error
        }
    }
}
