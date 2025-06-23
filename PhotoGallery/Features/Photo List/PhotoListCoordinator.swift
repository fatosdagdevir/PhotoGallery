import SwiftUI

struct PhotoListCoordinator: View {
    @ObservedObject var navigator: Navigator
    let photoListService: PhotoListing
    let photoDetailService: PhotoDetailing
    
    @StateObject private var viewModel: PhotoListViewModel
    
    init(
        navigator: Navigator,
        photoListService: PhotoListing,
        photoDetailService: PhotoDetailing
    ) {
        self.navigator = navigator
        self.photoListService = photoListService
        self.photoDetailService = photoDetailService
        self._viewModel = StateObject(wrappedValue: PhotoListViewModel(
            navigator: navigator,
            photoListService: photoListService
        ))
    }
    
    var body: some View {
        PhotoListView(viewModel: viewModel)
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case let .photoDetail(id):
                    PhotoDetailCoordinator(
                        photoID: id,
                        photoDetailService: photoDetailService
                    )
                }
            }
    }
}

