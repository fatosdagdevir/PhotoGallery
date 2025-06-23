import XCTest
@testable import PhotoGallery

@MainActor
final class PhotoProviderTests: XCTestCase {
    private var sut: PhotoProvider!
    private var mockNetwork: MockNetwork!
    
    override func setUp() {
        super.setUp()
        mockNetwork = MockNetwork()
        sut = PhotoProvider(network: mockNetwork)
    }
    
    override func tearDown() {
        sut = nil
        mockNetwork = nil
        super.tearDown()
    }
    
    func test_fetchPhotoGallery_success() async throws {
        // Given
        mockNetwork.mockData = createPhotoGalleryJSON()
        
        // When
        let result = try await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockNetwork.sendCallCount, 1)
        XCTAssertEqual(result.count, 3)
        
        let firstPhoto = try XCTUnwrap(result.first)
        XCTAssertEqual(firstPhoto.id, 1)
        XCTAssertEqual(firstPhoto.title, "Test Photo 1")
        XCTAssertEqual(firstPhoto.url, "https://via.placeholder.com/600/92c952")
        XCTAssertEqual(firstPhoto.thumbnailUrl, "https://via.placeholder.com/150/92c952")
        
        let secondPhoto = result[1]
        XCTAssertEqual(secondPhoto.id, 2)
        XCTAssertEqual(secondPhoto.title, "Test Photo 2")
    }
    
    func test_fetchPhotoGallery_emptyResponse_returnsEmptyArray() async throws {
        // Given
        mockNetwork.mockData = createEmptyGalleryJSON()
        
        // When
        let result = try await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockNetwork.sendCallCount, 1)
        XCTAssertTrue(result.isEmpty)
    }
    
    // MARK: - Fetch Photo Detail Tests
    
    func test_fetchPhotoDetail_success() async throws {
        // Given
        mockNetwork.mockData = createPhotoDetailJSON()
        
        // When
        let result = try await sut.fetchPhotoDetail(with: 1)
        
        // Then
        XCTAssertEqual(mockNetwork.sendCallCount, 1)
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "Test Photo Detail")
        XCTAssertEqual(result.url, "https://via.placeholder.com/600/92c952")
        XCTAssertEqual(result.thumbnailUrl, "https://via.placeholder.com/150/92c952")
    }
    
    func test_fetchPhotoGallery_networkError() async {
        // Given
        mockNetwork.mockError = NetworkError.serverError(500)
        
        // When & Then
        do {
            _ = try await sut.fetchPhotoGallery()
            XCTFail("Expected error")
        } catch NetworkError.offline {
            XCTFail("Unexpected offline error")
        } catch NetworkError.serverError(let code) {
            XCTAssertEqual(code, 500)
        } catch NetworkError.decodingError {
            XCTFail("Unexpected decoding error")
        } catch MockNetwork.MockError.missingMockData {
            XCTFail("Unexpected missing mock data")
        } catch MockNetwork.MockError.invalidResponse {
            XCTFail("Unexpected invalid response")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        XCTAssertEqual(mockNetwork.sendCallCount, 1)
    }
    
    func test_fetchPhotoGallery_missingMockData() async {
        // Given
        mockNetwork.mockData = nil
        
        // When & Then
        do {
            _ = try await sut.fetchPhotoGallery()
            XCTFail("Expected error")
        } catch NetworkError.offline {
            XCTFail("Unexpected offline error")
        } catch NetworkError.serverError(let code) {
            XCTFail("Unexpected server error: \(code)")
        } catch NetworkError.decodingError {
            XCTFail("Unexpected decoding error")
        } catch MockNetwork.MockError.missingMockData {
            // Expected missing mock data error
        } catch MockNetwork.MockError.invalidResponse {
            XCTFail("Unexpected invalid response")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
        
        XCTAssertEqual(mockNetwork.sendCallCount, 1)
    }
    
    func test_fetchPhotoGallery_multipleCalls_callsNetworkMultipleTimes() async throws {
        // Given
        mockNetwork.mockData = createEmptyGalleryJSON()
        
        // When
        _ = try await sut.fetchPhotoGallery()
        _ = try await sut.fetchPhotoGallery()
        _ = try await sut.fetchPhotoGallery()
        
        // Then
        XCTAssertEqual(mockNetwork.sendCallCount, 3)
    }
    
    // MARK: - Helpers
    private func createPhotoGalleryJSON() -> Data {
        return loadTestData(from: "photo_gallery")
    }
    
    private func createPhotoDetailJSON() -> Data {
        return loadTestData(from: "photo_detail")
    }
    
    private func createEmptyGalleryJSON() -> Data {
        return loadTestData(from: "empty_gallery")
    }
    
    private func loadTestData(from fileName: String) -> Data {
        guard let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json"),
              let data = NSData(contentsOfFile: path) as Data? else {
            XCTFail("Could not load test data from \(fileName).json")
            return Data()
        }
        return data
    }
}
