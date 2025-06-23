import SwiftUI

extension PreviewProvider {
    static var previewPhotos: [Photo] {
        [
            .init(id: 1, title: "Summer in Berlin", url: "", thumbnailUrl: ""),
            .init(id: 2, title: "Winter in Berlin", url: "", thumbnailUrl: ""),
            .init(id: 3, title: "Italy Vacation", url: "", thumbnailUrl: "")
        ]
    }
}
