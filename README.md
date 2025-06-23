# Networking

A lightweight, protocol-oriented Swift networking package for modern iOS applications.

## Features

- 🔌 **Protocol-oriented design** for easy testing and dependency injection
- 🌐 **Async/await support** for modern Swift concurrency
- 🛡️ **Type-safe requests** with associated types
- 🔧 **Comprehensive error handling** with network-specific errors
- 📱 **iOS 16+ and macOS 13+ support**
- 🧪 **Fully testable** with mock implementations

## Installation

### Swift Package Manager

Add this package to your project via Xcode or by adding it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "path/to/Networking", from: "1.0.0")
]
```

## Usage

### 1. Define an Endpoint

```swift
import Networking

struct PhotosEndpoint: EndpointProtocol {
    let host = "jsonplaceholder.typicode.com"
    let path = "/photos"
}
```

### 2. Create a Request

```swift
struct PhotosRequest: RequestProtocol {
    typealias Response = [Photo]
    
    let endpoint: any EndpointProtocol
    let method: HTTP.Method = .GET
}
```

### 3. Make the Network Call

```swift
let network = Network()
let endpoint = PhotosEndpoint()
let request = PhotosRequest(endpoint: endpoint)

do {
    let photos = try await network.send(request: request)
    print("Received \(photos.count) photos")
} catch {
    print("Network error: \(error)")
}
```

## Advanced Usage

### Custom Headers

```swift
struct AuthenticatedRequest: RequestProtocol {
    typealias Response = UserData
    
    let endpoint: any EndpointProtocol
    let method: HTTP.Method = .GET
    
    var headers: [String: String] {
        ["Authorization": "Bearer \(token)"]
    }
}
```

### POST Requests with Body

```swift
struct CreateUserRequest: RequestProtocol {
    typealias Response = User
    typealias Body = CreateUserBody
    
    let endpoint: any EndpointProtocol
    let method: HTTP.Method = .POST
    let body: CreateUserBody?
}
```

### Error Handling

```swift
do {
    let result = try await network.send(request: request)
} catch let networkError as NetworkError {
    switch networkError {
    case .offline:
        // Handle offline state
    case .serverError(let code):
        // Handle server errors
    case .decodingError:
        // Handle JSON decoding errors
    default:
        // Handle other errors
    }
}
```

## Testing

The package includes protocols that make testing easy:

```swift
class MockNetwork: Networking {
    var mockResponse: Any?
    var mockError: Error?
    
    func send<Request: RequestProtocol>(request: Request) async throws -> Request.Response {
        if let error = mockError {
            throw error
        }
        return mockResponse as! Request.Response
    }
}
```

## Requirements

- iOS 16.0+
- macOS 13.0+
- Swift 5.9+

## License

This project is available under the MIT license. 