//
//  ViewController.swift
//  Movie
//
//  Created by new on 7/1/22.
//

import UIKit

class ViewController: UIViewController {
    
    var safeArea: UILayoutGuide {
        return self.view.safeAreaLayoutGuide
    }
    
    var posters: [MovieInfo] = []
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 12
        return stack
    }()
    
    var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.placeholder = "Search for movie: "
        bar.returnKeyType = .go
        return bar
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureStackView()
        configureSearchBar()
        configureTableView()
    }
    
    func configureStackView() {
        view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    func configureSearchBar() {
        searchBar.delegate = self
        stackView.addArrangedSubview(searchBar)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "posterCell")
        tableView.allowsSelection = false
        stackView.addArrangedSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "posterCell")
        let poster = posters[indexPath.row]
        
        MovieController.fetchURL(poster: poster) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    cell.imageView?.image = url
                case .failure(let error):
                    print(error)
                    cell.imageView?.image = UIImage(systemName: "puppy")
                }
                cell.textLabel?.text = poster.title
                if let rating = poster.rating {
                cell.detailTextLabel?.text = "Rating: \(rating)"
            }
        }
        }
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchBar.text,
              !searchTerm.isEmpty else { return }
        searchBar.resignFirstResponder()
        MovieController.fetchMovieInfo(with: searchTerm) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let poster):
                    self.posters = poster
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

