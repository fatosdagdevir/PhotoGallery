import XCTest
import SwiftUI
@testable import PhotoGallery

@MainActor
final class NavigatorTests: XCTestCase {
    private var navigator: Navigator!
    
    override func setUp() {
        super.setUp()
        navigator = Navigator()
    }
    
    override func tearDown() {
        navigator = nil
        super.tearDown()
    }
    
    func test_init_createsEmptyPath() {
        // Then
        XCTAssertTrue(navigator.path.isEmpty)
    }
    
    func test_navigateToDestination_addsToPath() {
        // Given
        let destination = NavigationDestination.photoDetail(id: 1)
        
        // When
        navigator.navigate(to: destination)
        
        // Then
        XCTAssertEqual(navigator.path.count, 1)
    }
    
    func test_navigateToMultipleDestinations_addsAllToPath() {
        // Given
        let destinations: [NavigationDestination] = [
            .photoDetail(id: 1),
            .photoDetail(id: 2),
            .photoDetail(id: 3)
        ]
        
        // When
        for destination in destinations {
            navigator.navigate(to: destination)
        }
        
        // Then
        XCTAssertEqual(navigator.path.count, 3)
    }
    
    func test_navigateBack_removesLastDestination() {
        // Given
        navigator.navigate(to: .photoDetail(id: 1))
        navigator.navigate(to: .photoDetail(id: 2))
        XCTAssertEqual(navigator.path.count, 2)
        
        // When
        navigator.navigateBack()
        
        // Then
        XCTAssertEqual(navigator.path.count, 1)
    }
    
    func test_navigateBack_onEmptyPath_doesNothing() {
        // Given
        XCTAssertTrue(navigator.path.isEmpty)
        
        // When
        navigator.navigateBack()
        
        // Then
        XCTAssertTrue(navigator.path.isEmpty)
    }
    
    func test_navigateToRoot_clearsAllDestinations() {
        // Given
        navigator.navigate(to: .photoDetail(id: 1))
        navigator.navigate(to: .photoDetail(id: 2))
        navigator.navigate(to: .photoDetail(id: 3))
        XCTAssertEqual(navigator.path.count, 3)
        
        // When
        navigator.navigateToRoot()
        
        // Then
        XCTAssertTrue(navigator.path.isEmpty)
    }
    
    func test_navigateToRoot_onEmptyPath_doesNothing() {
        // Given
        XCTAssertTrue(navigator.path.isEmpty)
        
        // When
        navigator.navigateToRoot()
        
        // Then
        XCTAssertTrue(navigator.path.isEmpty)
    }
    
    func test_navigateToPhotoDetail_addsPhotoIdToPath() {
        // Given
        let photoId = 1
        
        // When
        navigator.navigate(to: .photoDetail(id: photoId))
        
        // Then
        XCTAssertEqual(navigator.path.count, 1)
    }
    
    func test_complexNavigationFlow() {
        // Given
        let photoId1 = 1
        let photoId2 = 2
        
        // When - Navigate to multiple destinations
        navigator.navigate(to: .photoDetail(id: photoId1))
        navigator.navigate(to: .photoDetail(id: photoId2))
        navigator.navigate(to: .photoDetail(id: 3))
        navigator.navigate(to: .photoDetail(id: 4))
        
        // Then
        XCTAssertEqual(navigator.path.count, 4)
        
        // When - Navigate back twice
        navigator.navigateBack()
        navigator.navigateBack()
        
        // Then
        XCTAssertEqual(navigator.path.count, 2)
        
        // When - Navigate to root
        navigator.navigateToRoot()
        
        // Then
        XCTAssertTrue(navigator.path.isEmpty)
    }
}
