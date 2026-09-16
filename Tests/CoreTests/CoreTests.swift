//
//  CoreTests.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import XCTest
import Combine
@testable import Core

// Mock Repository at file scope to prevent nesting violation
struct MockRepository: Repository {
    typealias Request = String
    typealias Response = [String]

    let shouldFail: Bool

    func execute(request: String?) -> AnyPublisher<[String], Error> {
        if shouldFail {
            return Fail(error: DatabaseError.requestFailed).eraseToAnyPublisher()
        } else {
            let req = request ?? ""
            let items = !req.isEmpty ? ["Result for \(req)"] : ["Default 1", "Default 2"]
            return Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
}

final class CoreTests: XCTestCase {
    private var cancellables: Set<AnyCancellable> = []

    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }

    func testInteractorSuccess() {
        let repo = MockRepository(shouldFail: false)
        let interactor = Interactor(repository: repo)
        let expectation = expectation(description: "Interactor should return data")

        interactor.execute(request: "Test")
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { values in
                XCTAssertEqual(values.count, 1)
                XCTAssertEqual(values.first, "Result for Test")
                expectation.fulfill()
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }

    func testInteractorFailure() {
        let repo = MockRepository(shouldFail: true)
        let interactor = Interactor(repository: repo)
        let expectation = expectation(description: "Interactor should fail")

        interactor.execute(request: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssertEqual(error.localizedDescription, DatabaseError.requestFailed.localizedDescription)
                    expectation.fulfill()
                case .finished:
                    XCTFail("Expected failure but succeeded")
                }
            }, receiveValue: { _ in
                XCTFail("Should not receive value")
            })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)
    }

    func testCustomErrors() {
        let dbError1 = DatabaseError.invalidInstance
        XCTAssertEqual(dbError1.localizedDescription, "Database can't instance.")

        let dbError2 = DatabaseError.requestFailed
        XCTAssertEqual(dbError2.localizedDescription, "Your request failed.")

        let urlError1 = URLError.invalidResponse
        XCTAssertEqual(urlError1.localizedDescription, "The server responded with an invalid response.")

        if let testURL = URL(string: "https://api.rawg.io") {
            let urlError2 = URLError.addressUnreachable(testURL)
            XCTAssertTrue(urlError2.localizedDescription.contains("https://api.rawg.io"))
        }
    }
}
