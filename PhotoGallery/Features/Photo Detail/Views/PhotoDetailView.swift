import SwiftUI

struct PhotoDetailView: View {
    enum ViewState {
        case loading
        case ready(photo: PhotoDetail)
        case error(viewModel: ErrorViewModel)
    }
    
    private enum Layout {
        static let verticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 20
        static let titleSpacing: CGFloat = 8
        static let placeholderHeight: CGFloat = 300
        static let imageMaxHeight: CGFloat = 400
    }
    
    @ObservedObject var viewModel: PhotoDetailViewModel
    
    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .accessibilityLabel("Loading photo details...")
            case .ready(let photo):
                content(photo: photo)
                    .refreshable {
                        await viewModel.refresh()
                    }
            case .error(let viewModel):
                ErrorView(viewModel: viewModel)
            }
        }
        .task {
            await viewModel.fetchPhotoDetail()
        }
    }
    
    // MARK: - Photo Detail Content
    @ViewBuilder
    private func content(photo: PhotoDetail) -> some View {
        ScrollView {
            VStack(spacing: Layout.verticalPadding) {
                // Header Image
                NetworkImageView(
                    url: URL(string: photo.url),
                    content: { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: Layout.imageMaxHeight)
                    },
                    placeholder: {
                        placeholderView
                    }
                )
                .accessibilityLabel("Photo image")
                
                // Photo Details
                VStack(alignment: .leading, spacing: Layout.titleSpacing) {
                    Text("Title")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(photo.title)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Layout.horizontalPadding)
                
                Spacer()
            }
            .padding(.vertical, Layout.verticalPadding)
        }
        .accessibilityLabel("Photo Detail")
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: Layout.placeholderHeight)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray)
                    .font(.largeTitle)
            )
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        
        // MARK: Ready
        NavigationView {
            PhotoDetailView(
                viewModel: previewPhotoDetailViewModel(
                    state: .ready(photo: previewPhotoDetail)
                )
            )
        }
        
        // MARK: Loading
        NavigationView {
            PhotoDetailView(
                viewModel: previewPhotoDetailViewModel(state: .loading)
            )
        }
        
        // MARK: Error
        NavigationView {
            PhotoDetailView(
                viewModel: previewPhotoDetailViewModel(
                    state: .error(viewModel: previewErrorViewModel)
                )
            )
        }
    }
}
