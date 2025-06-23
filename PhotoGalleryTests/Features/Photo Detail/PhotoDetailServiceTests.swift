import XCTest
@testable import PhotoGallery

@MainActor
final class PhotoDetailServiceTests: XCTestCase {
    private var service: PhotoDetailService!
    private var mockPhotoProvider: MockPhotoProvider!
    
    override func setUp() {
        super.setUp()
        mockPhotoProvider = MockPhotoProvider()
        service = PhotoDetailService(photoProvider: mockPhotoProvider)
    }
    
    override func tearDown() {
        service = nil
        mockPhotoProvider = nil
        super.tearDown()
    }
    
    func test_init_withValidDependencies_createsService() {
        XCTAssertNotNil(service)
        XCTAssertEqual(mockPhotoProvider.fetchPhotoDetailCallCount, 0)
    }
     
    func test_fetchPhotoDetail_onSuccess_returnsPhotoDetail() async throws {
        // Given
        let expectedPhotoDetail: PhotoDetail = .mock
        mockPhotoProvider.fetchPhotoDetailResult = .success(expectedPhotoDetail)
        
        // When
        let result = try await service.fetchPhotoDetail(id: 1)
        
        // Then
        XCTAssertEqual(mockPhotoProvider.fetchPhotoDetailCallCount, 1)
        XCTAssertEqual(mockPhotoProvider.lastFetchPhotoDetailID, 1)
        XCTAssertEqual(result.id, expectedPhotoDetail.id)
        XCTAssertEqual(result.title, expectedPhotoDetail.title)
        XCTAssertEqual(result.url, expectedPhotoDetail.url)
        XCTAssertEqual(result.thumbnailUrl, expectedPhotoDetail.thumbnailUrl)
    }
    
    func test_fetchPhotoDetail_onFailure_returnsError() async {
        // Given
        let expectedError = NetworkError.offline
        mockPhotoProvider.fetchPhotoDetailResult = .failure(expectedError)
        
        // When
        let result = await fetchPhotoDetailResult(id: 1)
        
        // Then
        guard case .failure(let error) = result else {
            XCTFail("Expected error to be thrown")
            return
        }
        
        guard error is NetworkError else {
            XCTFail("Expected NetworkError to be thrown")
            return
        }
        
        XCTAssertEqual(mockPhotoProvider.fetchPhotoDetailCallCount, 1)
        XCTAssertEqual(mockPhotoProvider.lastFetchPhotoDetailID, 1)
    }
    
    func test_fetchPhotoDetail_onDecodingError_propagatesError() async {
        // Given
        let decodingError = NetworkError.decodingError
        mockPhotoProvider.fetchPhotoDetailResult = .failure(decodingError)
        
        // When
        let result = await fetchPhotoDetailResult(id: 1)
        
        // Then
        guard case .failure(let error) = result else {
            XCTFail("Expected error to be thrown")
            return
        }
        
        guard error is NetworkError else {
            XCTFail("Expected NetworkError to be thrown")
            return
        }
        
        XCTAssertEqual(mockPhotoProvider.fetchPhotoDetailCallCount, 1)
    }
    
    func test_fetchPhotoDetail_onServerError_propagatesError() async {
        // Given
        let serverError = NetworkError.serverError(500)
        mockPhotoProvider.fetchPhotoDetailResult = .failure(serverError)
        
        // When
        let result = await fetchPhotoDetailResult(id: 1)
        
        // Then
        guard case .failure(let error) = result else {
            XCTFail("Expected error to be thrown")
            return
        }
        
        guard error is NetworkError else {
            XCTFail("Expected NetworkError to be thrown")
            return
        }
        
        XCTAssertEqual(mockPhotoProvider.fetchPhotoDetailCallCount, 1)
    }
    
    func test_fetchPhotoDetail_onNetworkTimeout_propagatesError() async {
        // Given
        let timeoutError = URLError(.timedOut)
        mockPhotoProvider.fetchPhotoDetailResult = .failure(timeoutError)
        
        // When
        let result = await fetchPhotoDetailResult(id: 1)
        
        // Then
        guard case .failure(let error) = result else {
            XCTFail("Expected error to be thrown")
            return
        }
        
        XCTAssertEqual(mockPhotoProvider.fetchPhotoDetailCallCount, 1)
    }
    
    // MARK: - Helper Methods
    private func fetchPhotoDetailResult(id: Int) async -> Result<PhotoDetail, Error> {
        do {
            let result = try await service.fetchPhotoDetail(id: id)
            return .success(result)
        } catch {
            return .failure(error)
        }
    }
}
