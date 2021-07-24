//
//  LoginViewController.swift
//  Todo
//
//  Created by James on 7/23/21.
//

import UIKit
import Auth0

final class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "Todo"
        label.font = UIFont.systemFont(ofSize: 40, weight: .black)
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "GraphQL Client with Hasura"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        
        SessionManager.shared.patchMode = false
        self.checkToken() {
            self.showLogin()
        }
    }
    
    // MARK: - API
    
    fileprivate func showLogin() {
        guard let clientInfo = plistValues(bundle: Bundle.main) else { return }
        SessionManager.shared.patchMode = true
        Auth0
            .webAuth()
            .scope("openid profile offline_access read:current_user update:current_user_metadata")
            .audience("https://" + clientInfo.domain + "/api/v2/")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    if(!SessionManager.shared.store(credentials: credentials)) {
                        print("Failed to store credentials")
                    } else {
                        SessionManager.shared.retrieveProfile { error in
                            DispatchQueue.main.async {
                                guard error == nil else {
                                    print("Failed to retrieve profile: \(String(describing: error))")
                                    return self.showLogin()
                                }
                                NetworkManager.shared.createApolloClient(accessToken: credentials.idToken!)
                                let vc = HomeViewController()
                                vc.modalPresentationStyle = .fullScreen
                                self.present(vc, animated: true, completion: nil)
                                
                            }
                        }
                    }
                }
            }
    }
    
    fileprivate func checkToken(callback: @escaping () -> Void) {
        SessionManager.shared.renewAuth { error in
            DispatchQueue.main.async {
                    SessionManager.shared.retrieveProfile { [weak self] error in
                        DispatchQueue.main.async {
                            guard error == nil else {
                                print("Failed to retrieve profile: \(String(describing: error))")
                                return callback()
                            }
                            NetworkManager.shared.createApolloClient(accessToken: (SessionManager.shared.credentials?.idToken!)!)
                            let vc = HomeViewController()
                            vc.modalPresentationStyle = .fullScreen
                            self?.present(vc, animated: true, completion: nil)

                        }
                    }
                }
            }
        }
    
    // MARK: - Helpers
    
    private func configureLayout() {
        view.backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 40
        view.addSubview(stack)
        stack.center(inView: view)
    }
}
