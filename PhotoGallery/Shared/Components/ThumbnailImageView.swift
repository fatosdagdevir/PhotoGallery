import SwiftUI

struct ThumbnailImageView: View {
    let imageURL: String
    let size: CGFloat
    let cornerRadius: CGFloat
    
    init(
        imageURL: String,
        size: CGFloat = 60,
        cornerRadius: CGFloat = 8
    ) {
        self.imageURL = imageURL
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    var body: some View {
        NetworkImageView(
            url: URL(string: imageURL),
            content: { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            },
            placeholder: {
                placeholderView
            }
        )
        .accessibilityHidden(true)
    }
    
    @ViewBuilder
    private var placeholderView: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.gray.opacity(0.3))
            .frame(width: size, height: size)
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        ThumbnailImageView(imageURL: "https://via.placeholder.com/150/92c952")
        ThumbnailImageView(imageURL: "invalid-url", size: 80, cornerRadius: 12)
        ThumbnailImageView(imageURL: "", size: 40, cornerRadius: 4)
    }
    .padding()
} 
