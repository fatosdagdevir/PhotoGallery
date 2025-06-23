import SwiftUI

extension PreviewProvider {
    static func previewPhotoListViewModel(state: PhotoListView.ViewState) -> PhotoListViewModel {
        let photoProvider = PhotoProvider()
        let photoListService = PhotoListService(photoProvider: photoProvider)
        let viewModel = PhotoListViewModel(
            navigator: Navigator(),
            photoListService: photoListService,
            isPreview: true
        )
        viewModel.viewState = state
        return viewModel
    }
}
