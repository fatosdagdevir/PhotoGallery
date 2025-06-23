# PhotoGallery

A modern iOS photo gallery application built with SwiftUI and modular architecture.

### Features
- **Photo List**: Browse photos from API with thumbnail images
- **Photo Detail**: View full-size photos with detailed information

## Requirements

- iOS 18.5+
- Xcode 16.0+
- Swift 6.0+

## Installation

1. Clone the repository
```bash
git clone https://github.com/fatosdagdevir/PhotoGallery.git
```

2. Open `PhotoGallery.xcworkspace` in Xcode (not .xcodeproj)

3. Build and run the project

## Project Structure

```
PhotoGallery/
├── PhotoGallery.xcworkspace     ← Open this file
├── PhotoGallery.xcodeproj       ← Main app project
├── Packages/                    ← Local packages
│   └── Networking/             ← Networking package
│       ├── Package.swift
│       ├── Sources/Networking/
│       └── Tests/
├── PhotoGallery/               ← Main app code
│   ├── App/
│   ├── Core/
│   ├── Features/
│   ├── Shared/
│   └── Resources/
└── PhotoGalleryTests/          ← App tests
```


### Current Architecture
- **MVVM-C (Model-View-ViewModel-Coordinator)**: Clean separation of concerns with Coordinators handling navigation.
- **Modular Design**: Networking layer extracted into its own Swift package for better maintainability.
- **Protocol-Oriented Programming**: Use of protocols for dependency injection and testability.
- **Dependency Injection**: Container pattern for managing dependencies.


### ✅ **Two Things Solved Well**

1. **Clean Architecture Principles**: The app follows clean architecture principles with clear separation of concerns. Even though this is a simple app, every layer has been designed to be clean and scalable. Business logic has been properly extracted - for example, `PhotoDetailService` handles the business logic for photo details rather than embedding it directly in ViewModels or Views.

2. **Modular & Testable Design**: Extracted the networking layer into its own Swift package, demonstrating how to create modular, reusable components. The protocol-oriented approach with dependency injection makes every component easily testable and replaceable.

### 🔧 **Things to Improve with More Time**

1. **Image Caching & Performance**: Add caching for images so they don't reload every time. Use NSCache for quick access and save to disk for when the app restarts. Load images only when needed and preload some images ahead of time.

2. **Pagination**: API returns 5000 entries and pagination needs to be introduced to load photos in smaller chunks for better performance and user experience.

3. **Move Core & Reusable Views to Package**: Extract shared components like ErrorView, NetworkImageView, and common extensions into their own package for better reusability across projects.

4. **Networking Package Unit Tests**: Add comprehensive unit tests for the Networking package to ensure all network operations, error handling, and request/response parsing work correctly.

5. **Architecture Review**: I always used MVVM-C with UIKit applications and tried to adopt it to SwiftUI application but I might need to give a more careful thought since navigation is tightly coupled with views in SwiftUI.
