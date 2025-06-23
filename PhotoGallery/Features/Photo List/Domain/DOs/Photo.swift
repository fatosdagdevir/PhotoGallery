import Foundation

struct Photo: Identifiable, Equatable {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
