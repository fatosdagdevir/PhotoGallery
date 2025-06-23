import Foundation

@MainActor
final class PhotoDetailViewModel: ObservableObject {
    private let photoDetailService: PhotoDetailing
    private let photoID: Int
    
    @Published var viewState: PhotoDetailView.ViewState = .loading
    
    init(photoID: Int, photoDetailService: PhotoDetailing) {
        self.photoID = photoID
        self.photoDetailService = photoDetailService
    }
    
    func fetchPhotoDetail() async {
        do {
            let photo = try await photoDetailService.fetchPhotoDetail(id: photoID)
            viewState = .ready(photo: photo)
        } catch {
            handleError(error)
        }
    }
    
    func refresh() async {
        viewState = .loading
        await fetchPhotoDetail()
    }
    
    //MARK: Private Helpers
    private func handleError(_ error: Error) {
        viewState = .error(
            viewModel: ErrorViewModel(
                error: NetworkError.handle(error),
                action: { [weak self] in
                    await self?.refresh()
                }
            )
        )
    }
} 
