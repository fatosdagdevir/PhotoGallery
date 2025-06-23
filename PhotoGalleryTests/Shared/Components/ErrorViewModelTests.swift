import XCTest
@testable import PhotoGallery

@MainActor
final class ErrorViewModelTests: XCTestCase {
    
    func test_init_withValidParameters_createsViewModel() {
        // Given
        let error = NetworkError.offline
        let action: () async -> Void = { }
        
        // When
        let viewModel = ErrorViewModel(error: error, action: action)
        
        // Then
        XCTAssertNotNil(viewModel)
    }
    
    func test_offlineError_setsOfflineTexts() {
        // Given
        let error = NetworkError.offline
        let viewModel = ErrorViewModel(error: error) {}
        
        // Then
        XCTAssertEqual(viewModel.headerText, "You are offline!")
        XCTAssertEqual(viewModel.descriptionText, "Please check your internet connection and try again.")
        XCTAssertEqual(viewModel.buttonTitle, "Retry")
    }
    
    func test_genericError_setsGenericTexts() {
        // Given
        let error = NSError(domain: "Test", code: 0)
        let viewModel = ErrorViewModel(error: error) {}
        
        // Then
        XCTAssertEqual(viewModel.headerText, "Oops!")
        XCTAssertEqual(viewModel.descriptionText, "Something wrong happened try again.")
        XCTAssertEqual(viewModel.buttonTitle, "Retry")
    }
    
    func test_viewModelsWithSameType_areEqual() {
        // Given
        let error1 = NSError(domain: "Generic", code: 1)
        let error2 = NSError(domain: "Other", code: 2)
        let vm1 = ErrorViewModel(error: error1) {}
        let vm2 = ErrorViewModel(error: error2) {}
        
        // Then
        XCTAssertEqual(vm1, vm2)
    }
    
    func test_action_isCalled() async {
        // Given
        let expectation = XCTestExpectation(description: "Action called")
        
        let viewModel = ErrorViewModel(error: NSError(domain: "", code: 0)) {
            @MainActor in
            expectation.fulfill()
        }
        
        // When
        await viewModel.action()
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
