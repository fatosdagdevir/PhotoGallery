import XCTest
@testable import PhotoGallery

@MainActor
final class DependencyContainerTests: XCTestCase {
    private var container: DependencyContainer!
    
    override func setUp() {
        super.setUp()
        container = DependencyContainer()
    }
    
    override func tearDown() {
        container = nil
        super.tearDown()
    }
    
    func test_init_createsAllRequiredDependencies() {
        XCTAssertNotNil(container.navigator)
        XCTAssertNotNil(container.network)
        XCTAssertNotNil(container.photoProvider)
        XCTAssertNotNil(container.photoListService)
    }
    
    func test_network_isCorrectType() {
        XCTAssertTrue(container.network is Network)
    }
    
    func test_photoProvider_isCorrectType() {
        XCTAssertTrue(container.photoProvider is PhotoProvider)
    }
    
    func test_photoListService_isCorrectType() {
        XCTAssertTrue(container.photoListService is PhotoListService)
    }
}
