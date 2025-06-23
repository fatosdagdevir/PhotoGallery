import SwiftUI

struct PhotoListRowView: View {
    let photo: Photo
    let onTap: () -> Void

    private enum Layout {
        static let horizontalSpacing: CGFloat = 12
        static let chevronPadding: CGFloat = 4
    }

    var body: some View {
        HStack(spacing: Layout.horizontalSpacing) {
            ThumbnailImageView(imageURL: photo.thumbnailUrl)
            Text(photo.title)
                .font(.subheadline)
                .multilineTextAlignment(.leading)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .padding(.leading, Layout.chevronPadding)
                .accessibilityHidden(true)
        }
        .padding()
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(photo.title)
        .accessibilityHint("Double tap to view photo details")
        .accessibilityAddTraits(.isButton)
        Divider()
            .foregroundColor(.gray)
            .accessibilityHidden(true)
    }
}
