//
//  User.swift
//  GitHubUserSearch
//
//  Created by Süha Karakaya on 3.07.2025.
//

import Foundation

struct User: Decodable {
    let login: String
    let avatar_url: String
}

struct UserSearchResult: Decodable {
    let items: [User]
}
