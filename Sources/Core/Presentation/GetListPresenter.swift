//
//  GetListPresenter.swift
//  Core
//
//  Created by Baren Baruna Harahap on 16/09/26.
//

import SwiftUI
import Combine

open class GetListPresenter<
    Request,
    Response,
    Interactor: UseCase
>: ObservableObject where
    Interactor.Request == Request,
    Interactor.Response == [Response] {

    private var cancellables: Set<AnyCancellable> = []
    private let useCase: Interactor

    @Published public var list: [Response] = []
    @Published public var errorMessage: String = ""
    @Published public var isLoading: Bool = false
    @Published public var isError: Bool = false

    public init(useCase: Interactor) {
        self.useCase = useCase
    }

    public func getList(request: Request?) {
        isLoading = true
        isError = false
        errorMessage = ""

        useCase.execute(request: request)
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
