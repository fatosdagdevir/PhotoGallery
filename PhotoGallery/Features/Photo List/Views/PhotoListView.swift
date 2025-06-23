import SwiftUI

struct PhotoListView: View {
    enum ViewState {
        case loading
        case ready(photos: [Photo])
        case error(viewModel: ErrorViewModel)
    }
    
    private enum Layout {
        static let vSpacing: CGFloat = 4
        static let verticalPadding: CGFloat = 16
    }
    
    @ObservedObject var viewModel: PhotoListViewModel
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .accessibilityLabel("Loading photo gallery...")
            case .ready(let photos):
                content(photos: photos)
                    .refreshable {
                        await viewModel.refresh()
                    }
            case .error(let viewModel):
                ErrorView(viewModel: viewModel)
            }
        }
        .onFirstAppear {
            guard !viewModel.isPreview else { return }
            await viewModel.fetchPhotoGallery()
        }
    }
    
    // MARK: - Photo List View
    @ViewBuilder
    private func content(photos: [Photo]) -> some View {
        ScrollView {
            LazyVStack(spacing: Layout.vSpacing) {
                ForEach(photos, id: \.id) { photo in
                    PhotoListRowView(photo: photo) {
                        viewModel.didSelect(photo: photo)
                    }
                }
            }
            .padding(.vertical, Layout.verticalPadding)
        }
        .navigationTitle(viewModel.navigationTitle)
        .accessibilityLabel("Photo Gallery")
        .accessibilityAction(named: "Refresh List") {
            Task {
                await viewModel.refresh()
            }
        }
        .accessibilityHint("Double tap to refresh the photo list")
    }
}

struct PhotoListView_Previews: PreviewProvider {
    static var previews: some View {
        
        // MARK: Ready
        NavigationView {
            PhotoListView(
                viewModel: previewPhotoListViewModel(
                    state: .ready(photos: previewPhotos)
                )
            )
        }
        
        // MARK: Loading
        NavigationView {
            PhotoListView(
                viewModel: previewPhotoListViewModel(state: .loading)
            )
        }
        
        // MARK: Error
        NavigationView {
            PhotoListView(
                viewModel: previewPhotoListViewModel(
                    state: .error(viewModel: previewErrorViewModel)
                )
            )
        }
    }
}
