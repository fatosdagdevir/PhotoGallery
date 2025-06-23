@testable import PhotoGallery

// MARK: - Mock Photo Details
extension PhotoDetail {
    static var mock: PhotoDetail {
        .init(id: 1, title: "Test Photo", url: "test.com", thumbnailUrl: "thumb.com")
    }
}
