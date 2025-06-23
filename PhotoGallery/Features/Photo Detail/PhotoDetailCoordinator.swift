import SwiftUI

struct PhotoDetailCoordinator: View {
    let photoID: Int
    let photoDetailService: PhotoDetailing
    
    @StateObject private var viewModel: PhotoDetailViewModel
    
    init(photoID: Int, photoDetailService: PhotoDetailing) {
        self.photoID = photoID
        self.photoDetailService = photoDetailService
        self._viewModel = StateObject(
            wrappedValue: PhotoDetailViewModel(photoID: photoID, photoDetailService: photoDetailService)
        )
    }
    
    var body: some View {
        PhotoDetailView(viewModel: viewModel)
    }
}

#Preview {
    NavigationView {
        PhotoDetailCoordinator(
            photoID: 1,
            photoDetailService: PhotoDetailService(photoProvider: PhotoProvider())
        )
    }
}
