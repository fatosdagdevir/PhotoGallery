import SwiftUI

struct PhotoListCoordinator: View {
    enum PhotoListDestination: Hashable {
        case photoDetail(id: Int)
    }
    
    @ObservedObject var navigator: Navigator
    
    var body: some View {
        let viewModel = PhotoListViewModel(navigator: navigator)
        return PhotoListView(viewModel: viewModel)
            .navigationDestination(for: PhotoListDestination.self, destination: { destination in
                switch destination {
                case let .photoDetail(id):
                    PhotoDetailView()
                }
            })
    }
}

