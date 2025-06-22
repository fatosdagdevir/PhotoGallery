import SwiftUI

struct PhotoListCoordinator: View {
    enum PhotoListDestination: Hashable {
        case photoDetail(id: Int)
    }
    
    @ObservedObject var navigator: Navigator
    let photoListService: PhotoListing
    
    @StateObject private var viewModel: PhotoListViewModel
    
    init(navigator: Navigator, photoListService: PhotoListing) {
        self.navigator = navigator
        self.photoListService = photoListService
        self._viewModel = StateObject(wrappedValue: PhotoListViewModel(
            navigator: navigator,
            photoListService: photoListService
        ))
    }
    
    var body: some View {
        PhotoListView(viewModel: viewModel)
            .navigationDestination(for: PhotoListDestination.self, destination: { destination in
                switch destination {
                case let .photoDetail(id):
                    PhotoDetailView()
                }
            })
    }
}

