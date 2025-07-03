//
//  ViewController.swift
//  GitHubUserSearch
//
//  Created by Süha Karakaya on 3.07.2025.
//

import UIKit

class UserSearchViewController: UIViewController {
    
    // MARK: - UI Elements
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    
    // MARK: - ViewModel
    
    private let viewModel = UserSearchViewModel()
    private var users: [User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    private func setupUI() {
        title = "GitHub Search"
        view.backgroundColor = .systemBackground
        
        searchBar.delegate = self
        
        // SearchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search GitHub users"
        view.addSubview(searchBar)
        
        // TableView
        tableView.dataSource = self
        tableView.register(UserCell.self, forCellReuseIdentifier: "UserCell")
        view.addSubview(tableView)
        
        // AutoLayout
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        viewModel.searchUsers(query: query)
        searchBar.resignFirstResponder() // Klavyeyi kapatmak için
    }
    
    private func setupBindings() {
        viewModel.onUsersUpdated = { [weak self] users in
            self?.users = users
            self?.tableView.reloadData()
        }
    }
    
    private func showLoadingIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
}

extension UserSearchViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        viewModel.searchUsers(query: searchText)
//    }
}


extension UserSearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as? UserCell else {
            return UITableViewCell()
        }

        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }
}

