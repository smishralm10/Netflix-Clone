//
//  LoginViewController.swift
//  Netflix Clone
//
//  Created by Shreyansh Mishra on 26/09/22.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    
    private var cancellables = [AnyCancellable]()
    private let viewModel: LoginViewModelType
    private let appear = PassthroughSubject<Void, Never>()
    private let login = PassthroughSubject<(String, String), Never>()
    
    init(viewModel: LoginViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not supported")
    }
    
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
        textField.autocapitalizationType = .none
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
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
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
        view.addSubview(errorLabel)
        view.addSubview(signInLabel)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(signInButton)
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        applyConstraints()
        bind(to: viewModel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        appear.send(())
    }
    
    private func bind(to: LoginViewModelType) {
        let input = LoginViewModelInput(appear: self.appear.eraseToAnyPublisher(), login: self.login.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink { [weak self] state in
            self?.updateUI(with: state)
        }
        .store(in: &cancellables)
    }
    
    private func updateUI(with state: LoginState) {
        switch state {
        case .idle:
            errorLabel.isHidden = true
        case .loading:
            startLoadingAnimation()
        case .invalidUsername(let errorMessage):
            displayError(for: [usernameTextField], with: errorMessage)
        case .invalidPassword(let errorMessage):
            displayError(for: [passwordTextField], with: errorMessage)
        case .success:
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.appCoordinator.start()
            stopLoadingAnimation()
        case .failure(let error):
            displayError(for: [usernameTextField, passwordTextField], with: "Invalid Username or Password")
            stopLoadingAnimation()
            print(error)
        }
    }
    
    private func displayError(for textFields: [UITextField], with message: String){
        errorLabel.isHidden = false
        errorLabel.text = message
        textFields.forEach { textField in
            textField.layer.borderWidth = 2
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.cornerRadius = 5
        }
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
        isValidUsername(username) else {
            updateUI(with: .invalidUsername("Username Should be at least 3 characters"))
            return
        }
        
        guard let password = passwordTextField.text,
              isValidPassword(password) else {
            updateUI(with: .invalidPassword("Password should not be empty"))
            return
        }
        
        login.send((username, password))
    }
    
    func isValidUsername(_ username: String) -> Bool {
        if username.count < 3 {
            return false
        }
        return true
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
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
            
            errorLabel.topAnchor.constraint(equalTo: netflixLogo.bottomAnchor, constant: 20),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
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

extension LoginViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.white.cgColor
        textField.layer.cornerRadius = 5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 0
    }
}
