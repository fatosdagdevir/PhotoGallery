import Foundation

struct PhotoDTO: Codable {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    var mapped: Photo {
        .init(
            id: id,
            title: title,
            url: url,
            thumbnailUrl: thumbnailUrl
        )
    }
}
