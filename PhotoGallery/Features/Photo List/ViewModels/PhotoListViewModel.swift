import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    private let navigator: Navigator
    private let photoListService: PhotoListing

    init(
        navigator: Navigator,
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

