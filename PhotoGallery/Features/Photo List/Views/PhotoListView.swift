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
        static let chevronPadding: CGFloat = 4
        static let horizontalSpacing: CGFloat = 12
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
        .task {
            await viewModel.fetchPhotoGallery()
        }
    }
    
    // MARK: - Photo List View
    @ViewBuilder
    private func content(photos: [Photo]) -> some View {
        ScrollView {
            LazyVStack(spacing: Layout.vSpacing) {
                ForEach(photos, id: \.id) { photo in
                    photoRow(photo: photo)
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
    
    // MARK: - Photo Row View
    @ViewBuilder
    private func photoRow(photo: Photo) -> some View {
        HStack(spacing: Layout.horizontalSpacing) {
            ThumbnailImageView(imageURL: photo.thumbnailUrl)
            
            Text(photo.title)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            chevronIcon
        }
        .padding()
        .background(
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.didSelect(photo: photo)
                }
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel(photo.title)
        .accessibilityHint("Double tap to view photo details")
        .accessibilityAddTraits(.isButton)
        
        Divider()
            .foregroundColor(.gray)
            .accessibilityHidden(true)
    }
    
    @ViewBuilder
    private var chevronIcon: some View {
        Image(systemName: "chevron.right")
            .foregroundColor(.gray)
            .padding(.leading, Layout.chevronPadding)
            .accessibilityHidden(true)
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
