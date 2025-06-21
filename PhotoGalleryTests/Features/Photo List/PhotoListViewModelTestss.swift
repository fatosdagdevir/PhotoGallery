import XCTest
@testable import PhotoGallery

@MainActor
final class PhotoListViewModelTests: XCTestCase {
    private var viewModel: PhotoListViewModel!
    private var mockPhotoListService: MockPhotoListService!
    private var mockNavigator: MockNavigator!
    
    override func setUp() {
        super.setUp()
        mockPhotoListService = MockPhotoListService()
        mockNavigator = MockNavigator()
        viewModel = PhotoListViewModel(
            navigator: mockNavigator,
            photoListService: mockPhotoListService
        )
    }
    
    override func tearDown() {
        viewModel = nil
        mockPhotoListService = nil
        mockNavigator = nil
        super.tearDown()
    }
    
    func test_init_withValidDependencies_createsViewModel() {
        // Then
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 0)
        XCTAssertEqual(mockNavigator.navigatedToDestinations.count, 0)
    }
    
    func test_fetchPhotoGallery_onSuccess_callsPhotoListService() async {
        // Given
        let expectedPhotos = [
            Photo(id: 1, title: "Photo 1", url: "photo1.com", thumbnailUrl: "thumb1.com"),
            Photo(id: 2, title: "Photo 2", url: "photo2.com", thumbnailUrl: "thumb2.com")
        ]
        mockPhotoListService.fetchPhotosResult = .success(expectedPhotos)
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_onFailure_handlesError() async {
        // Given
        let expectedError = NetworkError.offline
        mockPhotoListService.fetchPhotosResult = .failure(expectedError)
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_onEmptyResponse_handlesEmptyArray() async {
        // Given
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_onDecodingError_handlesDecodingError() async {
        // Given
        let decodingError = NetworkError.decodingError
        mockPhotoListService.fetchPhotosResult = .failure(decodingError)
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_onServerError_handlesServerError() async {
        // Given
        let serverError = NetworkError.serverError(500)
        mockPhotoListService.fetchPhotosResult = .failure(serverError)
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_onNetworkTimeout_handlesTimeout() async {
        // Given
        let timeoutError = URLError(.timedOut)
        mockPhotoListService.fetchPhotosResult = .failure(timeoutError)
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_handlesAsyncOperation() async {
        // Given
        let expectation = XCTestExpectation(description: "Async operation completed")
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        Task {
            await viewModel.fetchPhotoGallery()
            expectation.fulfill()
        }
        
        // Then
        await fulfillment(of: [expectation], timeout: 1.0)
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_multipleCalls_callsServiceMultipleTimes() async {
        // Given
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        await viewModel.fetchPhotoGallery()
        await viewModel.fetchPhotoGallery()
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 3)
    }
    
    func test_fetchPhotoGallery_usesInjectedPhotoListService() async {
        // Given
        let customService = MockPhotoListService()
        let customViewModel = PhotoListViewModel(
            navigator: mockNavigator,
            photoListService: customService
        )
        customService.fetchPhotosResult = .success([])
        
        // When
        await customViewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(customService.fetchPhotosCallCount, 1)
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 0)
    }
    
    func test_fetchPhotoGallery_usesInjectedNavigator() {
        // Given
        let customNavigator = MockNavigator()
        let customViewModel = PhotoListViewModel(
            navigator: customNavigator,
            photoListService: mockPhotoListService
        )
        
        // Then
        XCTAssertNotNil(customViewModel)
        XCTAssertEqual(customNavigator.navigatedToDestinations.count, 0)
    }
    
    func test_fetchPhotoGallery_onLargePhotoArray_handlesLargeDataSet() async {
        // Given
        let largePhotoArray = (1...1000).map { index in
            Photo(
                id: index,
                title: "Photo \(index)",
                url: "photo\(index).com",
                thumbnailUrl: "thumb\(index).com"
            )
        }
        mockPhotoListService.fetchPhotosResult = .success(largePhotoArray)
        
        // When
        await viewModel.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
    }
    
    func test_fetchPhotoGallery_onConcurrentCalls_handlesConcurrency() async {
        // Given
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<5 {
                group.addTask {
                    await self.viewModel.fetchPhotoGallery()
                }
            }
        }
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 5)
    }
}
