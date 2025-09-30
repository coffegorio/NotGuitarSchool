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
        
        view.addSubview(greetingsTitle)
        view.addSubview(headlineTitle)
        view.addSubview(codeTextField)
        view.addSubview(enterButton)
        
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
        
        // Заголовки
        let topAnchor = authAnimationView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor
        let topConstant: CGFloat = authAnimationView != nil ? 24 : 40
        
        constraints.append(contentsOf: [
            // Заголовки по центру
            greetingsTitle.topAnchor.constraint(equalTo: topAnchor, constant: topConstant),
            greetingsTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingsTitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            greetingsTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            headlineTitle.topAnchor.constraint(equalTo: greetingsTitle.bottomAnchor, constant: 12),
            headlineTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headlineTitle.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            headlineTitle.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16),
            
            // Текстфилд по центру
            codeTextField.topAnchor.constraint(equalTo: headlineTitle.bottomAnchor, constant: 24),
            codeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            codeTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            codeTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Кнопка по центру
            enterButton.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 16),
            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.widthAnchor.constraint(equalTo: codeTextField.widthAnchor),
            enterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate(constraints)
    }
}
