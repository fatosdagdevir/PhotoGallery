import SwiftUI

extension PreviewProvider {
    static func previewPhotoDetailViewModel(state: PhotoDetailView.ViewState) -> PhotoDetailViewModel {
        let photoProvider = PhotoProvider()
        let photoDetailService = PhotoDetailService(photoProvider: photoProvider)
        let viewModel = PhotoDetailViewModel(
            photoID: 1,
            photoDetailService: photoDetailService,
            isPreview: true
        )
        viewModel.viewState = state
        return viewModel
    }
}
