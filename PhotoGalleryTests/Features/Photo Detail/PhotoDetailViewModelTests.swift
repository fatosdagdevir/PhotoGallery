import XCTest
@testable import PhotoGallery

@MainActor
final class PhotoDetailViewModelTests: XCTestCase {
    private var sut: PhotoDetailViewModel!
    private var mockPhotoDetailService: MockPhotoDetailService!
    
    override func setUp() {
        super.setUp()
        mockPhotoDetailService = MockPhotoDetailService()
        sut = PhotoDetailViewModel(
            photoID: 1,
            photoDetailService: mockPhotoDetailService
        )
    }
    
    override func tearDown() {
        sut = nil
        mockPhotoDetailService = nil
        super.tearDown()
    }
    

    func test_init_withValidDependencies_createsViewModel() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.viewState, .loading)
        XCTAssertFalse(sut.isPreview)
        XCTAssertEqual(mockPhotoDetailService.fetchPhotoDetailCallCount, 0)
    }
    
    func test_init_withPreviewFlag_setsPreviewFlag() {
        // Given
        let previewViewModel = PhotoDetailViewModel(
            photoID: 1,
            photoDetailService: mockPhotoDetailService,
            isPreview: true
        )
        
        // Then
        XCTAssertTrue(previewViewModel.isPreview)
    }
    
    func test_fetchPhotoDetail_onSuccess_updatesViewStateToReady() async {
        // Given
        let expectedPhotoDetail: PhotoDetail = .mock
        mockPhotoDetailService.fetchPhotoDetailResult = .success(expectedPhotoDetail)
        
        // When
        await sut.fetchPhotoDetail()
        
        // Then
        XCTAssertEqual(mockPhotoDetailService.fetchPhotoDetailCallCount, 1)
        XCTAssertEqual(mockPhotoDetailService.lastFetchPhotoID, 1)
        
        guard case .ready(let photo) = sut.viewState else {
            XCTFail("Expected .ready state")
            return
        }
        
        XCTAssertEqual(photo.id, expectedPhotoDetail.id)
        XCTAssertEqual(photo.title, expectedPhotoDetail.title)
    }
    
    func test_fetchPhotoDetail_onOfflineError_showsOfflineError() async {
        // Given
        let expectedError = NetworkError.offline
        mockPhotoDetailService.fetchPhotoDetailResult = .failure(expectedError)
        
        // When
        await sut.fetchPhotoDetail()
        
        // Then
        XCTAssertEqual(mockPhotoDetailService.fetchPhotoDetailCallCount, 1)
        
        guard case .error(let errorViewModel) = sut.viewState else {
            XCTFail("Expected error state")
            return
        }
        
        XCTAssertEqual(errorViewModel.headerText, "You are offline!")
        XCTAssertEqual(errorViewModel.descriptionText, "Please check your internet connection and try again.")
    }
    
    func test_fetchPhotoDetails_failure_updatesViewStateWithError() async {
        // Given
        let expectedError = NetworkError.invalidStatus(500)
        mockPhotoDetailService.fetchPhotoDetailResult = .failure(expectedError)
        
        // When
        await sut.fetchPhotoDetail()
        
        // Then
        guard case .error(let errorViewModel) = sut.viewState else {
            XCTFail("Expected error state")
            return
        }
        XCTAssertEqual(errorViewModel.headerText, "Oops!")
        XCTAssertEqual(mockPhotoDetailService.fetchPhotoDetailCallCount, 1)
    }
    
    
    func test_refresh_setsLoadingStateAndFetchesData() async {
        // Given
        let expectedPhotoDetail: PhotoDetail = .mock
        mockPhotoDetailService.fetchPhotoDetailResult = .success(expectedPhotoDetail)
        
        // Set initial state to error
        sut.viewState = .error(viewModel: ErrorViewModel(error: NetworkError.offline, action: {}))
        
        // When
        await sut.refresh()
        
        // Then
        guard case .ready(let photo) = sut.viewState else {
            XCTFail("Expected .ready state")
            return
        }
        
        XCTAssertEqual(photo.id, expectedPhotoDetail.id)
        XCTAssertEqual(mockPhotoDetailService.fetchPhotoDetailCallCount, 1)
    }
    
    func test_errorViewModel_hasRefreshAction() async {
        // Given
        mockPhotoDetailService.fetchPhotoDetailResult = .failure(NetworkError.offline)
        
        // When - First call fails
        await sut.fetchPhotoDetail()
        
        // Then - Verify error state
        guard case .error(let errorViewModel) = sut.viewState else {
            XCTFail("Expected error state")
            return
        }
        
        // When - Retry
        mockPhotoDetailService.fetchPhotoDetailResult = .success(.mock)
        await errorViewModel.action()
        
        // Then - Verify second call
        XCTAssertEqual(mockPhotoDetailService.fetchPhotoDetailCallCount, 2)
    }
} 
