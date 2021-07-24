//
//  HomeViewController.swift
//  Todo
//
//  Created by James on 7/23/21.
//

import UIKit
import Auth0
import Apollo

final class HomeViewController: UIViewController {
    
    // MARK: - Properties
    
    var todos: [GetMyTodosQuery.Data.Todo] = []
    private var tableView = UITableView(frame: .zero)
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if( SessionManager.shared.credentials?.idToken! == nil ) {
            DispatchQueue.main.async { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        queryTodos()
    }
    
    // MARK: - API
    
    private func queryTodos(){
        
        if( SessionManager.shared.credentials?.idToken! != nil ) {
            NetworkManager.shared.apolloClient?.fetch(query: GetMyTodosQuery()) { [weak self] result in
                
                switch result {
                
                case .success(let graphQLResult):
                    if let todos = graphQLResult.data?.todos.compactMap({ $0 }) {
                        self?.todos.append(contentsOf: todos)
                        self?.tableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("DEBUG: \(error)")
                    return
                }
            }
        } else {
            print("token is nil")
        }
    }
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = "ID: \(todo.id) Title: \(todo.title)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
}

