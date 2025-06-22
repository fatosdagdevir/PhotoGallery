import Foundation

@MainActor
final class PhotoListViewModel: ObservableObject {
    private let navigator: Navigating
    private let photoListService: PhotoListing

    @Published var viewState: PhotoListView.ViewState = .loading
    
    var navigationTitle: String { "Photo Gallery" }
    
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
        
    }
    
    //MARK: Error Handling
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

