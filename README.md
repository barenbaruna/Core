# Core Module (Generic Clean Architecture Framework)

This module provides generic protocols and base implementations for Clean Architecture in Swift, inspired by Dicoding's iOS Expert curriculum.

## Protocols
- `DataSource`: Generic protocol for data sources.
- `LocaleDataSource`: Generic protocol for locale data operations (CRUD).
- `Repository`: Generic protocol for data repositories.
- `UseCase`: Generic protocol for domain use cases.
- `Mapper`: Generic protocol for converting data between Response, Entity, and Domain.

## Implementations
- `Interactor`: Generic implementation of `UseCase` backed by a `Repository`.
- `GetListPresenter`: Generic observable presenter for list views.
- `Presenter`: Generic observable presenter for detail views.
- `SearchPresenter`: Generic observable presenter for search views.

## Installation
Add as a Swift Package:
```swift
dependencies: [
    .package(url: "https://github.com/barenbaruna/Core.git", from: "1.0.0")
]
```
