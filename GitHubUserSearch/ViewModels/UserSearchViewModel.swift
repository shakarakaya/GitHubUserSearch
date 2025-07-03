//
//  UserSearchViewModel.swift
//  GitHubUserSearch
//
//  Created by Süha Karakaya on 3.07.2025.
//

import Foundation

class UserSearchViewModel {

    private let service: GitHubServiceProtocol
    private var searchTask: DispatchWorkItem?
    private var currentRequest: URLSessionDataTask?
    

    var onUsersUpdated: (([User]) -> Void)?
    var onLoadingStateChange: ((Bool) -> Void)?

    private(set) var users: [User] = [] {
        didSet {
            onUsersUpdated?(users)
        }
    }

    // MARK: - Init

    init(service: GitHubServiceProtocol = GitHubService()) {
        self.service = service
    }

    // MARK: - Search Logic

    func searchUsers(query: String) {
        searchTask?.cancel()

        // debounce: 0.5 saniye sonra aramayı başlat
        let task = DispatchWorkItem { [weak self] in
            self?.performSearch(query: query)
        }

        searchTask = task
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: task)
    }

    private func performSearch(query: String) {
        guard !query.isEmpty else {
            self.users = []
            return
        }

        // Yeni arama geldiğinde eski isteği iptal et
        currentRequest?.cancel()

        onLoadingStateChange?(true)

        currentRequest = service.searchUsers(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.onLoadingStateChange?(false)

                switch result {
                case .success(let fetchedUsers):
                    self?.users = fetchedUsers
                case .failure:
                    self?.users = []
                }
            }
        }
    }
}
