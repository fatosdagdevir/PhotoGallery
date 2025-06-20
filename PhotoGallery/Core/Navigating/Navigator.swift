import SwiftUI

protocol Navigating {
    func navigate(to destination: any Hashable)
    func navigateBack()
    func navigateToRoot()
}

final class Navigator: Navigating, ObservableObject {
    @Published public var path = NavigationPath()
    
    func navigate(to destination: any Hashable) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeLast(path.count)
    }
}
