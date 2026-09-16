//
//  SearchPresenter.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import SwiftUI
import Combine

open class SearchPresenter<
    Response,
    Interactor: UseCase
>: ObservableObject where
    Interactor.Request == String,
    Interactor.Response == [Response] {

    private var cancellables: Set<AnyCancellable> = []
    private let useCase: Interactor

    @Published public var list: [Response] = []
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false
    @Published public var keyword: String = ""

    public init(useCase: Interactor) {
        self.useCase = useCase
    }

    public func search() {
        isLoading = true
        isError = false
        errorMessage = ""

        useCase.execute(request: keyword)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isError = true
                    self.isLoading = false
                case .finished:
                    self.isLoading = false
                }
            }, receiveValue: { [weak self] list in
                self?.list = list
            })
            .store(in: &cancellables)
    }
}
