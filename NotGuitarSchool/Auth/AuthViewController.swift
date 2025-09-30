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
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        
        setupAnimation()
        
        // Устанавливаем translatesAutoresizingMaskIntoConstraints для всех компонентов
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
        
        view.addSubview(authAnimationView)
        authAnimationView.play()
    }
    
    private func setupConstraints() {
        var constraints: [NSLayoutConstraint] = []
        
        // Анимация сверху по центру (если загрузилась)
        if let authAnimationView = authAnimationView {
            constraints.append(contentsOf: [
                authAnimationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                authAnimationView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                authAnimationView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
                authAnimationView.heightAnchor.constraint(equalTo: authAnimationView.widthAnchor)
            ])
        }
        
        // Создаем контейнер для центрирования всех компонентов
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // Перемещаем компоненты в контейнер
        containerView.addSubview(greetingsTitle)
        containerView.addSubview(headlineTitle)
        containerView.addSubview(codeTextField)
        containerView.addSubview(enterButton)
        
        constraints.append(contentsOf: [
            // Контейнер по центру экрана
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            // Компоненты внутри контейнера - все одинаковой ширины
            greetingsTitle.topAnchor.constraint(equalTo: containerView.topAnchor),
            greetingsTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            greetingsTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            greetingsTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            headlineTitle.topAnchor.constraint(equalTo: greetingsTitle.bottomAnchor, constant: 12),
            headlineTitle.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            headlineTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            headlineTitle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            codeTextField.topAnchor.constraint(equalTo: headlineTitle.bottomAnchor, constant: 24),
            codeTextField.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            codeTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            codeTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            enterButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 16),
            enterButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            enterButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            enterButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            enterButton.heightAnchor.constraint(equalToConstant: 50),
            enterButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - Keyboard Handling
    
    private func setupKeyboardHandling() {
        // Добавляем наблюдатели для клавиатуры
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
        
        // Добавляем жест для скрытия клавиатуры при тапе на экран
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        
        // Анимированно поднимаем контент вверх
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 3)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        // Возвращаем контент в исходное положение
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut) {
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
