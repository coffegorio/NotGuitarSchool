//
//  AuthViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit
import Lottie

class AuthViewController: UIViewController {
    
    private let viewModel: AuthViewModel
    
    // MARK: - Инициализация
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI компоненты
    
    private var authAnimationView: LottieAnimationView?
    private var animationContainer: UIView? // <----- Сохраняем контейнер
    
    private lazy var greetingsTitle = AppLabel(
        text: viewModel.greetingsTitle,
        style: .greetings
    )
    
    private lazy var headlineTitle = AppLabel(
        text: viewModel.headlineTitle,
        style: .body
    )
    
    private lazy var codeTextField = AppTextField(
        placeholder: viewModel.enterCodePlaceholder,
        isFilled: true,
        color: .systemBlue
    )
    
    private lazy var enterButton = AppButton(title: viewModel.logInButtonTitle)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardHandling()
        setupActions()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        
        setupAnimation()
        
        greetingsTitle.translatesAutoresizingMaskIntoConstraints = false
        headlineTitle.translatesAutoresizingMaskIntoConstraints = false
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
        enterButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }
    
    private func setupAnimation() {
        authAnimationView = .init(name: "AuthViewAnimation")
        guard let authAnimationView = authAnimationView else { return }
        
        authAnimationView.translatesAutoresizingMaskIntoConstraints = false
        authAnimationView.contentMode = .scaleAspectFit
        authAnimationView.loopMode = .loop
        authAnimationView.animationSpeed = 1
        authAnimationView.play()
        
        // Создаём контейнер для анимации
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(authAnimationView)
        
        // Ограничения для самой анимации внутри контейнера
        NSLayoutConstraint.activate([
            authAnimationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            authAnimationView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            authAnimationView.widthAnchor.constraint(equalToConstant: 300),
            authAnimationView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        // Важно: ограничение по высоте для контейнера!
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 220) // немного больше, чтобы дать запас
        ])
        
        self.animationContainer = container
    }
    
    private func setupConstraints() {
        var arrangedSubviews: [UIView] = []
        if let animationContainer = animationContainer {
            arrangedSubviews.append(animationContainer)
        }
        
        let titleContainer = UIView()
        titleContainer.translatesAutoresizingMaskIntoConstraints = false
        titleContainer.addSubview(greetingsTitle)
        titleContainer.addSubview(headlineTitle)
        
        NSLayoutConstraint.activate([
            greetingsTitle.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            greetingsTitle.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            greetingsTitle.topAnchor.constraint(equalTo: titleContainer.topAnchor),
            
            headlineTitle.leadingAnchor.constraint(equalTo: titleContainer.leadingAnchor),
            headlineTitle.trailingAnchor.constraint(equalTo: titleContainer.trailingAnchor),
            headlineTitle.topAnchor.constraint(equalTo: greetingsTitle.bottomAnchor, constant: 12),
            headlineTitle.bottomAnchor.constraint(equalTo: titleContainer.bottomAnchor)
        ])
        
        arrangedSubviews.append(titleContainer)
        arrangedSubviews.append(contentsOf: [codeTextField, enterButton])
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        if animationContainer != nil {
            stackView.setCustomSpacing(24, after: arrangedSubviews[0])
        }
        stackView.setCustomSpacing(24, after: arrangedSubviews[arrangedSubviews.count - 3])
        stackView.setCustomSpacing(16, after: codeTextField)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            enterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    //MARK: - настройка действий
    
    private func setupActions() {
        enterButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        viewModel.navigateNextScreen()
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 5)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn) {
            self.view.transform = .identity
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
