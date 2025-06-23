import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    private let navigator: Navigating
    private let photoListService: PhotoListing

    @Published var viewState: PhotoListView.ViewState = .loading
    
    var navigationTitle: String { "Photo Gallery" }
    let isPreview: Bool
    
    init(
        navigator: Navigating,
        photoListService: PhotoListing,
        isPreview: Bool = false
    ) {
        self.navigator = navigator
        self.photoListService = photoListService
        self.isPreview = isPreview
    }
    
    func fetchPhotoGallery() async {
        do {
            let photos = try await photoListService.fetchPhotos()
            viewState = .ready(photos: photos)
        } catch {
            handleError(error)
        }
    }
    
    func refresh() async {
        viewState = .loading
        
        await fetchPhotoGallery()
    }
    
    func didSelect(photo: Photo) {
        navigator.navigate(to: .photoDetail(id: photo.id))
    }
    
    //MARK: Private Helpers
    private func handleError(_ error: Error) {
        viewState = .error(
            viewModel: ErrorViewModel(
                error: NetworkError.handle(error),
                action: {  [weak self] in
                    await self?.refresh()
                }
            )
        )
    }
}

