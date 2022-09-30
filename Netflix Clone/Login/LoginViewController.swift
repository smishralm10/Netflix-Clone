//
//  LoginViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 26/09/22.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private let viewModel = LoginViewModel()
    @Published var requestToken = ""
    var cancellables = Set<AnyCancellable>()
    
    private lazy var netflixLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "netflixLogoComplete")?.withRenderingMode(.alwaysOriginal).resizeTo(size: CGSize(width: view.bounds.width - 150, height: 80))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let signInLabel: UILabel = {
        let label = UILabel()
        label.text = "Sign In"
        label.textColor = .white
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(cgColor: CGColor(gray: 0.2 , alpha: 0.8))
        textField.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.textContentType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
        
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(cgColor: CGColor(gray: 0.2 , alpha: 0.8))
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        textField.textContentType = .password
        textField.isSecureTextEntry = true
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(self.handleSignIn), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(netflixLogo)
        view.addSubview(signInLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        
        fetchToken()
        applyConstraints()
    }

    private func fetchToken() {
        viewModel.getRequestToken()
            .sink { completion in
                if case let .failure(error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                if let token = response.requestToken {
                    self?.requestToken = token
                }
            }
            .store(in: &cancellables)
    }
    
    private func startLoadingAnimation() {
        signInButton.setTitle(nil, for: .normal)
        signInButton.addSubview(activityIndicator)
        centerActivityIndicator()
        activityIndicator.startAnimating()
    }
    
    
    private func stopLoadingAnimation() {
        signInButton.setTitle("Sign In", for: .normal)
        activityIndicator.stopAnimating()
    }
    
    private func centerActivityIndicator() {
        let xCenterConstraint = NSLayoutConstraint(item: signInButton, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        signInButton.addConstraint(xCenterConstraint)
            
        let yCenterConstraint = NSLayoutConstraint(item: signInButton, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        signInButton.addConstraint(yCenterConstraint)
    }
    
    @objc func handleSignIn(_ sender: UIButton) {
        guard let username = usernameTextField.text,
                isValidUsername(String(username)) else {
            showAlert(title: "Invalid Username", message: "Please enter a valid username")
            return
        }
        
        guard let password = passwordTextField.text,
              isValidPassword(String(password)) else {
            showAlert(title: "Invalid Password", message: "Password should contain atleast 6 characters")
            return
        }
        
        guard !self.requestToken.isEmpty else {
            showAlert(title: "Oops", message: "Something went wrong")
            return
        }
            
        startLoadingAnimation()
        viewModel.validateToken(username: username, password: password, requestToken: requestToken)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.showAlert(title: "Authentication Failed", message: error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard response.success,
                      let self = self,
                      let expiresAt = response.expiresAt,
                      let token = response.requestToken else {
                    return
                }
                self.requestToken = token
                
                self.viewModel.createSession(requestToken: token)
                    .sink { completion in
                        if case let .failure(error) = completion {
                            print(error.localizedDescription)
                        }
                    } receiveValue: { response in
                        if let sessionId = response.sessionId {
                            AuthorizationServiceProvider.shared.sessionId = sessionId
                            let userData = [
                                "username": username,
                                "expiresAt": expiresAt,
                                "requestToken": token,
                                "sessionId": sessionId
                            ]
                            UserDefaults.standard.set(userData, forKey: "currentUser")
                            let mainTabBarController = MainTabBarController()
                            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainTabBarController)
                            self.stopLoadingAnimation()
                        }
                    }
                    .store(in: &self.cancellables)
            }
            .store(in: &cancellables)
    }
    
    func isValidUsername(_ username: String) -> Bool {
        if username.count < 3 {
            return false
        }
        return true
    }
    
    func isValidPassword(_ password: String) -> Bool {
        if password.count < 6 {
            return false
        }
        return true
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            netflixLogo.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            netflixLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            signInLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signInLabel.topAnchor.constraint(equalTo: netflixLogo.bottomAnchor, constant: 80),
            
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            usernameTextField.topAnchor.constraint(equalTo: signInLabel.bottomAnchor, constant: 32),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 24),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}
