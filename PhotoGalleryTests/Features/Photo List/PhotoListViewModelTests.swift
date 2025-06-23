import XCTest
@testable import PhotoGallery

@MainActor
final class PhotoListViewModelTests: XCTestCase {
    private var sut: PhotoListViewModel!
    private var mockPhotoListService: MockPhotoListService!
    private var mockNavigator: MockNavigator!
    
    override func setUp() {
        super.setUp()
        mockPhotoListService = MockPhotoListService()
        mockNavigator = MockNavigator()
        sut = PhotoListViewModel(
            navigator: mockNavigator,
            photoListService: mockPhotoListService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockPhotoListService = nil
        mockNavigator = nil
        super.tearDown()
    }
    
    func test_init_createsViewModel() {
        // Then
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.viewState, .loading)
        XCTAssertFalse(sut.isPreview)
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 0)
        XCTAssertEqual(mockNavigator.navigatedToDestinations.count, 0)
        XCTAssertEqual(sut.navigationTitle, "Photo Gallery")
    }
    
    func test_init_withPreviewFlag_setsPreviewFlag() {
        // Given
        let previewViewModel = PhotoListViewModel(
            navigator: mockNavigator,
            photoListService: mockPhotoListService,
            isPreview: true
        )
        
        // Then
        XCTAssertTrue(previewViewModel.isPreview)
    }
    
    func test_fetchPhotoGallery_onSuccess_updatesViewStateToReady() async {
        // Given
        let expectedPhotos = [
            Photo(id: 1, title: "Photo 1", url: "photo1.com", thumbnailUrl: "thumb1.com"),
            Photo(id: 2, title: "Photo 2", url: "photo2.com", thumbnailUrl: "thumb2.com")
        ]
        mockPhotoListService.fetchPhotosResult = .success(expectedPhotos)
        
        // When
        await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
        
        guard case .ready(let photos) = sut.viewState else {
            XCTFail("Expected .ready state")
            return
        }
        
        XCTAssertEqual(photos.count, 2)
        XCTAssertEqual(photos[0].id, 1)
        XCTAssertEqual(photos[0].title, "Photo 1")
        XCTAssertEqual(photos[1].id, 2)
        XCTAssertEqual(photos[1].title, "Photo 2")
    }
    
    func test_fetchPhotoGallery_onFailure_updatesViewStateToError() async {
        // Given
        let expectedError = NetworkError.offline
        mockPhotoListService.fetchPhotosResult = .failure(expectedError)
        
        // When
        await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
        
        guard case .error(let errorViewModel) = sut.viewState else {
            XCTFail("Expected .error state")
            return
        }
        
        XCTAssertEqual(errorViewModel.headerText, "You are offline!")
        XCTAssertEqual(errorViewModel.descriptionText, "Please check your internet connection and try again.")
    }
    
    func test_fetchPhotoGallery_onEmptyResponse_updatesViewStateToReady() async {
        // Given
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
        
        guard case .ready(let photos) = sut.viewState else {
            XCTFail("Expected .ready state")
            return
        }
        
        XCTAssertTrue(photos.isEmpty)
    }
    
    func test_refresh_setsLoadingStateAndFetchesData() async {
        // Given
        let expectedPhotos = [Photo(id: 1, title: "Photo 1", url: "photo1.com", thumbnailUrl: "thumb1.com")]
        mockPhotoListService.fetchPhotosResult = .success(expectedPhotos)
        
        // Initial Error State
        sut.viewState = .error(viewModel: ErrorViewModel(error: NetworkError.offline, action: {}))
        
        // When
        await sut.refresh()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 1)
        
        guard case .ready(let photos) = sut.viewState else {
            XCTFail("Expected .ready state")
            return
        }
        
        XCTAssertEqual(photos.count, 1)
        XCTAssertEqual(photos[0].id, 1)
    }
    
    func test_didSelect_photo_navigatesToPhotoDetail() {
        // Given
        let photo = Photo(id: 42, title: "Test Photo", url: "test.com", thumbnailUrl: "thumb.com")
        
        // When
        sut.didSelect(photo: photo)
        
        // Then
        XCTAssertEqual(mockNavigator.navigatedToDestinations.count, 1)
        
        guard case .photoDetail(let photoID) = mockNavigator.navigatedToDestinations.first else {
            XCTFail("Expected photoDetail navigation")
            return
        }
        
        XCTAssertEqual(photoID, 42)
    }
    
    func test_errorViewModel_hasRefreshAction() async {
        // Given
        mockPhotoListService.fetchPhotosResult = .failure(NetworkError.offline)
        
        // When - First call fails
        await sut.fetchPhotoGallery()
        
        // Then - Verify error state
        guard case .error(let errorViewModel) = sut.viewState else {
            XCTFail("Expected error state")
            return
        }
        
        // When - Retry with success
        mockPhotoListService.fetchPhotosResult = .success([Photo(id: 1, title: "Test", url: "test.com", thumbnailUrl: "thumb.com")])
        await errorViewModel.action()
        
        // Then - Verify second call and state change
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 2)
        
        guard case .ready(let photos) = sut.viewState else {
            XCTFail("Expected .ready state after retry")
            return
        }
        
        XCTAssertEqual(photos.count, 1)
    }
    
    func test_fetchPhotoGallery_handlesAsyncOperation() async {
        // Given
        let expectation = XCTestExpectation(description: "Async operation completed")
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        Task {
            await sut.fetchPhotoGallery()
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
        await sut.fetchPhotoGallery()
        await sut.fetchPhotoGallery()
        await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 3)
    }
    
    func test_fetchPhotoGallery_onConcurrentCalls_handlesConcurrency() async {
        // Given
        mockPhotoListService.fetchPhotosResult = .success([])
        
        // When
        await withTaskGroup(of: Void.self) { group in
            for _ in 0..<5 {
                group.addTask {
                    await self.sut.fetchPhotoGallery()
                }
            }
        }
        
        // Then
        XCTAssertEqual(mockPhotoListService.fetchPhotosCallCount, 5)
    }
}
