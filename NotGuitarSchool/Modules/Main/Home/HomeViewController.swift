//
//  HomeViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class HomeViewController: UIViewController {

    private let greetingView = GreetingView()
    
    // Stats Cards
    private let statsStackView = UIStackView()
    private let lessonsCompletedCard = createStatsCard(title: "Уроков пройдено", value: "12", icon: "🎸", color: AppColors.primaryBlue)
    private let practiceTimeCard = createStatsCard(title: "Время практики", value: "2ч 30м", icon: "⏱️", color: AppColors.secondaryGreen)
    private let streakCard = createStatsCard(title: "Серия дней", value: "7", icon: "🔥", color: AppColors.accentOrange)
    
    // Quick Actions
    private let quickActionsTitle = AppLabel(
        text: "Быстрые действия",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    private let quickActionsStack = UIStackView()
    private let tunerButton = AppGradientButton(title: "🎵 Тюнер", gradient: AppGradients.primary)
    private let lessonsButton = AppGradientButton(title: "📚 Уроки", gradient: AppGradients.success)
    private let practiceButton = AppGradientButton(title: "🎯 Практика", gradient: AppGradients.warning)
    
    // Progress Section
    private let progressTitle = AppLabel(
        text: "Ваш прогресс",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    private let progressView = AppProgressView(progress: 0.65, progressColor: AppColors.primaryBlue)
    private let progressDescription = AppLabel(
        text: "Вы прошли 65% базового курса",
        style: .body,
        textColor: AppColors.textSecondary
    )
    
    // Featured Content
    private let featuredTitle = AppLabel(
        text: "Рекомендуем изучить",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    private let featuredCard = createFeaturedCard()
    
    private let showRegistryButtonTitle = AppLabel(
        text: "Хотите узнать, чьи песни нельзя исполнять на концерте? Мы собрали реестр таких артистов в одном месте:",
        style: .body,
        textColor: AppColors.textSecondary,
        numberOfLines: 0
    )
    private let showRegistryButton = AppButton(title: "Показать реестр 👀", isFilled: false)

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
        
        setupScrollView()
        setupStatsSection()
        setupQuickActionsSection()
        setupProgressSection()
        setupFeaturedSection()
        setupRegistrySection()
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        contentView.axis = .vertical
        contentView.spacing = AppSpacing.lg
        contentView.alignment = .fill
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: AppSpacing.lg),
            contentView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: AppSpacing.md),
            contentView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -AppSpacing.md),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -AppSpacing.lg),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -AppSpacing.xl)
        ])
    }
    
    private func setupStatsSection() {
        // Greeting
        contentView.addArrangedSubview(greetingView)
        greetingView.updateGreeting()
        
        // Stats Cards
        statsStackView.axis = .horizontal
        statsStackView.spacing = AppSpacing.md
        statsStackView.distribution = .fillEqually
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        statsStackView.addArrangedSubview(lessonsCompletedCard)
        statsStackView.addArrangedSubview(practiceTimeCard)
        statsStackView.addArrangedSubview(streakCard)
        
        contentView.addArrangedSubview(statsStackView)
        
        NSLayoutConstraint.activate([
            lessonsCompletedCard.heightAnchor.constraint(equalToConstant: 120),
            practiceTimeCard.heightAnchor.constraint(equalToConstant: 120),
            streakCard.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupQuickActionsSection() {
        contentView.addArrangedSubview(quickActionsTitle)
        
        quickActionsStack.axis = .horizontal
        quickActionsStack.spacing = AppSpacing.md
        quickActionsStack.distribution = .fillEqually
        quickActionsStack.translatesAutoresizingMaskIntoConstraints = false
        
        quickActionsStack.addArrangedSubview(tunerButton)
        quickActionsStack.addArrangedSubview(lessonsButton)
        quickActionsStack.addArrangedSubview(practiceButton)
        
        contentView.addArrangedSubview(quickActionsStack)
        
        NSLayoutConstraint.activate([
            tunerButton.heightAnchor.constraint(equalToConstant: 50),
            lessonsButton.heightAnchor.constraint(equalToConstant: 50),
            practiceButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupProgressSection() {
        contentView.addArrangedSubview(progressTitle)
        contentView.addArrangedSubview(progressView)
        contentView.addArrangedSubview(progressDescription)
    }
    
    private func setupFeaturedSection() {
        contentView.addArrangedSubview(featuredTitle)
        contentView.addArrangedSubview(featuredCard)
        
        NSLayoutConstraint.activate([
            featuredCard.heightAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    private func setupRegistrySection() {
        let registryStack = UIStackView(arrangedSubviews: [showRegistryButtonTitle, showRegistryButton])
        registryStack.axis = .vertical
        registryStack.spacing = AppSpacing.md
        contentView.addArrangedSubview(registryStack)
        
        showRegistryButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func setupActions() {
        showRegistryButton.addTarget(self, action: #selector(showRegistryTapped), for: .touchUpInside)
        tunerButton.addTarget(self, action: #selector(tunerButtonTapped), for: .touchUpInside)
        lessonsButton.addTarget(self, action: #selector(lessonsButtonTapped), for: .touchUpInside)
        practiceButton.addTarget(self, action: #selector(practiceButtonTapped), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func showRegistryTapped() {
        let agentsVC = AgentsViewController()
        let nav = UINavigationController(rootViewController: agentsVC)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    @objc private func tunerButtonTapped() {
        // Navigate to tuner
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 2 // Assuming tuner is at index 2
        }
    }
    
    @objc private func lessonsButtonTapped() {
        // Navigate to lessons
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 1 // Assuming lessons is at index 1
        }
    }
    
    @objc private func practiceButtonTapped() {
        // Navigate to practice/learning
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = 1
        }
    }
}

// MARK: - Helper Methods

extension HomeViewController {
    
    private static func createStatsCard(title: String, value: String, icon: String, color: UIColor) -> AppCardView {
        let card = AppCardView(
            backgroundColor: AppColors.surfacePrimary,
            cornerRadius: AppCornerRadius.lg,
            shadow: AppShadows.medium
        )
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        
        let valueLabel = AppLabel(
            text: value,
            style: .headline,
            textColor: color
        )
        valueLabel.textAlignment = .center
        
        let titleLabel = AppLabel(
            text: title,
            style: .caption,
            textColor: AppColors.textSecondary
        )
        titleLabel.textAlignment = .center
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, valueLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.xs
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: card.topAnchor, constant: AppSpacing.md),
            stackView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: AppSpacing.md),
            stackView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -AppSpacing.md),
            stackView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -AppSpacing.md)
        ])
        
        return card
    }
    
    private static func createFeaturedCard() -> AppGradientCardView {
        let card = AppGradientCardView(
            gradient: AppGradients.primary,
            cornerRadius: AppCornerRadius.lg,
            shadow: AppShadows.large
        )
        
        let titleLabel = AppLabel(
            text: "Аккорды для начинающих",
            style: .headline,
            textColor: AppColors.textInverse
        )
        
        let descriptionLabel = AppLabel(
            text: "Изучите основные аккорды и начните играть свои первые песни",
            style: .body,
            textColor: AppColors.textInverse.withAlphaComponent(0.9),
            numberOfLines: 0
        )
        
        let startButton = AppGradientButton(
            title: "Начать изучение",
            gradient: AppGradients.success,
            cornerRadius: AppCornerRadius.round
        )
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, startButton])
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.md
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: card.topAnchor, constant: AppSpacing.lg),
            stackView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: AppSpacing.lg),
            stackView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -AppSpacing.lg),
            stackView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -AppSpacing.lg),
            
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        return card
    }
}
