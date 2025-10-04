//
//  HomeViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class HomeViewController: UIViewController {

    private let greetingView = GreetingView()
    private let countdownContainer = AppContainerView(containerColor: AppColors.mainAccentColor)
    private let countdownTitleLabel = AppLabel(
        text: "До концерта осталось 🎤",
        style: .headline,
        textColor: AppColors.backgroundColor
    )
    private let countdownValueLabel = AppLabel(
        text: "🎵",
        style: .greetings,
        textColor: AppColors.backgroundColor
    )
    
    private let showRegistryButtonTitle = AppLabel(
        text: "Хотите узнать, чьи песни нельзя исполнять на концерте? Мы собрали реестр таких артистов в одном месте:",
        style: .headline,
        textColor: AppColors.textColor,
        numberOfLines: 0
    )
    private let showRegistryButton = AppButton(title: "Показать 👀", isFilled: false)

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        title = "Главная"
        
        // ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // ContentView
        contentView.axis = .vertical
        contentView.spacing = 24
        contentView.alignment = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40)
        ])
        
        // Greeting
        contentView.addArrangedSubview(greetingView)
        greetingView.updateGreeting()
        
        // Countdown
        let countdownStack = UIStackView(arrangedSubviews: [countdownTitleLabel, countdownValueLabel])
        countdownStack.axis = .vertical
        countdownStack.spacing = 8
        countdownStack.translatesAutoresizingMaskIntoConstraints = false
        countdownContainer.addSubview(countdownStack)
        
        NSLayoutConstraint.activate([
            countdownStack.topAnchor.constraint(equalTo: countdownContainer.topAnchor, constant: 16),
            countdownStack.leadingAnchor.constraint(equalTo: countdownContainer.leadingAnchor, constant: 16),
            countdownStack.trailingAnchor.constraint(equalTo: countdownContainer.trailingAnchor, constant: -16),
            countdownStack.bottomAnchor.constraint(equalTo: countdownContainer.bottomAnchor, constant: -16)
        ])
        contentView.addArrangedSubview(countdownContainer)
        
        // Registry section
        let registryStack = UIStackView(arrangedSubviews: [showRegistryButtonTitle, showRegistryButton])
        registryStack.axis = .vertical
        registryStack.spacing = 12
        contentView.addArrangedSubview(registryStack)
        
        showRegistryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupActions() {
        showRegistryButton.addTarget(self, action: #selector(showRegistryTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func showRegistryTapped() {
        let agentsVC = AgentsViewController()
        let nav = UINavigationController(rootViewController: agentsVC)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
}
