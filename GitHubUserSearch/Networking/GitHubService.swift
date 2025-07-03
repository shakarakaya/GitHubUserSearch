//
//  GitHubService.swift
//  GitHubUserSearch
//
//  Created by Süha Karakaya on 3.07.2025.
//

import Foundation

protocol GitHubServiceProtocol {
    @discardableResult
    func searchUsers(query: String, completion: @escaping (Result<[User], Error>) -> Void) -> URLSessionDataTask?
}

class GitHubService: GitHubServiceProtocol {
    func searchUsers(query: String, completion: @escaping (Result<[User], Error>) -> Void) -> URLSessionDataTask? {
        guard let url = URL(string: "https://api.github.com/search/users?q=\(query)") else {
            completion(.failure(NSError(domain: "InvalidURL", code: 0)))
            return nil
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error as NSError?, error.code == NSURLErrorCancelled {
                // İstek iptal edildiyse sessiz geç
                return
            }

            if let data = data {
                do {
                    let response = try JSONDecoder().decode(UserSearchResult.self, from: data)
                    completion(.success(response.items))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "NoData", code: 0)))
            }
        }

        task.resume()
        return task
    }
}

