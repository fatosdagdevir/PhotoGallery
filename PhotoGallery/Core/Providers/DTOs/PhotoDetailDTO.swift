import Foundation

struct PhotoDetailDTO: Codable {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    var mapped: PhotoDetail {
        .init(
            id: id,
            title: title,
            url: url,
            thumbnailUrl: thumbnailUrl
        )
    }
}
