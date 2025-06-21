import Foundation

public protocol Networking {
    var decoder: JSONDecoder { get }
    var encoder: JSONEncoder { get }
    
    func data(for request: some RequestProtocol) async throws -> (Data, URLResponse)
}

public extension Networking {
    func send<Request: RequestProtocol>(request: Request) async throws -> Request.Response {
        let (data, _) = try await data(for: request)
        return try decode(data: data)
    }
    
    func decode<T: Decodable>(data: Data) throws -> T {
        if T.self == EmptyResponse.self, let emptyResponse = EmptyResponse() as? T {
            return emptyResponse
        }
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}

struct Network: Networking {
    enum InternalError: Error {
        case invalidURL
    }
    
    let encoder: JSONEncoder
    let decoder: JSONDecoder
    let session: URLSession
    private let timeoutInterval: TimeInterval
    
    init(
        session: URLSession = URLSession.shared,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder(),
        timeoutInterval: TimeInterval = AppConstants.API.timeout
    ) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        self.timeoutInterval = timeoutInterval
    }
    
    func data(for request: some RequestProtocol) async throws -> (Data, URLResponse) {
        guard var urlRequest = try? URLRequest(
            endpoint: request.endpoint,
            method: request.method,
            timeoutInterval: timeoutInterval,
            headers: request.headers
        ) else {
            throw NetworkError.invalidURL
        }
        
        if let body = request.body {
            do {
                urlRequest.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.unknown
            }
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            if let error = NetworkError(response: response) {
                throw error
            }
            
            return (data, response)
        } catch {
            throw NetworkError.handle(error)
        }
    }
}
