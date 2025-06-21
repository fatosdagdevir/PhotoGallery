import Foundation
@testable import PhotoGallery

final class MockNavigator: Navigating {
    private(set) var navigatedToDestinations: [NavigationDestination] = []
    private(set) var navigateBackCallCount = 0
    private(set) var navigateToRootCallCount = 0

    func navigate(to destination: NavigationDestination) {
        navigatedToDestinations.append(destination)
    }

    func navigateBack() {
        navigateBackCallCount += 1
    }
    
    func navigateToRoot() {
        navigateToRootCallCount += 1
    }
    
    func reset() {
        navigatedToDestinations.removeAll()
        navigateBackCallCount = 0
        navigateToRootCallCount = 0
    }
    
    func wasNavigatedTo(_ destination: NavigationDestination) -> Bool {
        return navigatedToDestinations.contains(destination)
    }
    
    var lastDestination: NavigationDestination? {
        return navigatedToDestinations.last
    }
    
    func wasNavigatedToPhotoDetail(id: Int) -> Bool {
        return navigatedToDestinations.contains { destination in
            if case .photoDetail(let photoId) = destination {
                return photoId == id
            }
            return false
        }
    }
}
