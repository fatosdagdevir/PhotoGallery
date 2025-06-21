import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    private let navigator: Navigating
    private let photoListService: PhotoListing

    init(
        navigator: Navigating,
        photoListService: PhotoListing
    ) {
        self.navigator = navigator
        self.photoListService = photoListService
    }
    
    func fetchPhotoGallery() async {
        do {
            let photos = try await photoListService.fetchPhotos()
            print(photos)
        } catch {
            print(error)
        }
    }
}

