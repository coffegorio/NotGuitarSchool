//
//  ProfileViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    // Profile Header
    private let profileHeaderCard = AppGradientCardView(
        gradient: AppGradients.primary,
        cornerRadius: AppCornerRadius.lg,
        shadow: AppShadows.large
    )
    
    private let avatarImageView = UIImageView()
    private let nameLabel = AppLabel(
        text: "Гитарист",
        style: .headline,
        textColor: AppColors.textInverse
    )
    private let levelLabel = AppLabel(
        text: "Начинающий",
        style: .body,
        textColor: AppColors.textInverse.withAlphaComponent(0.9)
    )
    
    // Stats Section
    private let statsTitle = AppLabel(
        text: "Ваша статистика",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let statsStackView = UIStackView()
    private let totalLessonsCard = createStatCard(title: "Уроков пройдено", value: "12", icon: "📚", color: AppColors.primaryBlue)
    private let practiceTimeCard = createStatCard(title: "Время практики", value: "15ч 30м", icon: "⏱️", color: AppColors.secondaryGreen)
    private let streakCard = createStatCard(title: "Серия дней", value: "7", icon: "🔥", color: AppColors.accentOrange)
    private let accuracyCard = createStatCard(title: "Точность", value: "87%", icon: "🎯", color: AppColors.warningRed)
    
    // Progress Section
    private let progressTitle = AppLabel(
        text: "Прогресс обучения",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let overallProgressView = AppProgressView(progress: 0.65, progressColor: AppColors.primaryBlue)
    private let overallProgressLabel = AppLabel(
        text: "Общий прогресс: 65%",
        style: .body,
        textColor: AppColors.textSecondary
    )
    
    // Achievements Section
    private let achievementsTitle = AppLabel(
        text: "Достижения",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let achievementsStackView = UIStackView()
    
    // Settings Section
    private let settingsTitle = AppLabel(
        text: "Настройки",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let settingsStackView = UIStackView()
    private let notificationsButton = createSettingsButton(title: "Уведомления", icon: "🔔")
    private let soundButton = createSettingsButton(title: "Звук", icon: "🔊")
    private let helpButton = createSettingsButton(title: "Помощь", icon: "❓")
    private let aboutButton = createSettingsButton(title: "О приложении", icon: "ℹ️")

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        title = "Профиль"
        
        setupScrollView()
        setupProfileHeader()
        setupStatsSection()
        setupProgressSection()
        setupAchievementsSection()
        setupSettingsSection()
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
    
    private func setupProfileHeader() {
        // Avatar
        avatarImageView.image = UIImage(systemName: "person.circle.fill")
        avatarImageView.tintColor = AppColors.textInverse
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Profile info stack
        let profileStack = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, levelLabel])
        profileStack.axis = .vertical
        profileStack.spacing = AppSpacing.sm
        profileStack.alignment = .center
        profileStack.translatesAutoresizingMaskIntoConstraints = false
        
        profileHeaderCard.addSubview(profileStack)
        
        NSLayoutConstraint.activate([
            profileStack.topAnchor.constraint(equalTo: profileHeaderCard.topAnchor, constant: AppSpacing.lg),
            profileStack.leadingAnchor.constraint(equalTo: profileHeaderCard.leadingAnchor, constant: AppSpacing.lg),
            profileStack.trailingAnchor.constraint(equalTo: profileHeaderCard.trailingAnchor, constant: -AppSpacing.lg),
            profileStack.bottomAnchor.constraint(equalTo: profileHeaderCard.bottomAnchor, constant: -AppSpacing.lg),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        contentView.addArrangedSubview(profileHeaderCard)
        
        NSLayoutConstraint.activate([
            profileHeaderCard.heightAnchor.constraint(equalToConstant: 180)
        ])
    }
    
    private func setupStatsSection() {
        contentView.addArrangedSubview(statsTitle)
        
        statsStackView.axis = .horizontal
        statsStackView.spacing = AppSpacing.sm
        statsStackView.distribution = .fillEqually
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        statsStackView.addArrangedSubview(totalLessonsCard)
        statsStackView.addArrangedSubview(practiceTimeCard)
        
        let secondRowStack = UIStackView(arrangedSubviews: [streakCard, accuracyCard])
        secondRowStack.axis = .horizontal
        secondRowStack.spacing = AppSpacing.sm
        secondRowStack.distribution = .fillEqually
        
        let statsContainer = UIStackView(arrangedSubviews: [statsStackView, secondRowStack])
        statsContainer.axis = .vertical
        statsContainer.spacing = AppSpacing.sm
        
        contentView.addArrangedSubview(statsContainer)
        
        NSLayoutConstraint.activate([
            totalLessonsCard.heightAnchor.constraint(equalToConstant: 100),
            practiceTimeCard.heightAnchor.constraint(equalToConstant: 100),
            streakCard.heightAnchor.constraint(equalToConstant: 100),
            accuracyCard.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    private func setupProgressSection() {
        contentView.addArrangedSubview(progressTitle)
        contentView.addArrangedSubview(overallProgressView)
        contentView.addArrangedSubview(overallProgressLabel)
    }
    
    private func setupAchievementsSection() {
        contentView.addArrangedSubview(achievementsTitle)
        
        achievementsStackView.axis = .horizontal
        achievementsStackView.spacing = AppSpacing.md
        achievementsStackView.distribution = .fillEqually
        
        let achievement1 = createAchievementCard(title: "Первые шаги", description: "Пройден первый урок", icon: "🎸", isUnlocked: true)
        let achievement2 = createAchievementCard(title: "Неделя практики", description: "7 дней подряд", icon: "🔥", isUnlocked: true)
        let achievement3 = createAchievementCard(title: "Мастер аккордов", description: "Изучены все базовые аккорды", icon: "🎵", isUnlocked: false)
        
        achievementsStackView.addArrangedSubview(achievement1)
        achievementsStackView.addArrangedSubview(achievement2)
        achievementsStackView.addArrangedSubview(achievement3)
        
        contentView.addArrangedSubview(achievementsStackView)
        
        NSLayoutConstraint.activate([
            achievement1.heightAnchor.constraint(equalToConstant: 120),
            achievement2.heightAnchor.constraint(equalToConstant: 120),
            achievement3.heightAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func setupSettingsSection() {
        contentView.addArrangedSubview(settingsTitle)
        
        settingsStackView.axis = .vertical
        settingsStackView.spacing = AppSpacing.sm
        settingsStackView.distribution = .fillEqually
        
        settingsStackView.addArrangedSubview(notificationsButton)
        settingsStackView.addArrangedSubview(soundButton)
        settingsStackView.addArrangedSubview(helpButton)
        settingsStackView.addArrangedSubview(aboutButton)
        
        contentView.addArrangedSubview(settingsStackView)
        
        NSLayoutConstraint.activate([
            notificationsButton.heightAnchor.constraint(equalToConstant: 50),
            soundButton.heightAnchor.constraint(equalToConstant: 50),
            helpButton.heightAnchor.constraint(equalToConstant: 50),
            aboutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        notificationsButton.addTarget(self, action: #selector(notificationsTapped), for: .touchUpInside)
        soundButton.addTarget(self, action: #selector(soundTapped), for: .touchUpInside)
        helpButton.addTarget(self, action: #selector(helpTapped), for: .touchUpInside)
        aboutButton.addTarget(self, action: #selector(aboutTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func notificationsTapped() {
        // Handle notifications settings
        print("Notifications tapped")
    }
    
    @objc private func soundTapped() {
        // Handle sound settings
        print("Sound tapped")
    }
    
    @objc private func helpTapped() {
        // Handle help
        print("Help tapped")
    }
    
    @objc private func aboutTapped() {
        // Handle about
        print("About tapped")
    }
}

// MARK: - Helper Methods

extension ProfileViewController {
    
    private static func createStatCard(title: String, value: String, icon: String, color: UIColor) -> AppCardView {
        let card = AppCardView(
            backgroundColor: AppColors.surfacePrimary,
            cornerRadius: AppCornerRadius.md,
            shadow: AppShadows.small
        )
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 20)
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
        titleLabel.numberOfLines = 2
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, valueLabel, titleLabel])
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.xs
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: card.topAnchor, constant: AppSpacing.sm),
            stackView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: AppSpacing.sm),
            stackView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -AppSpacing.sm),
            stackView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -AppSpacing.sm)
        ])
        
        return card
    }
    
    private static func createAchievementCard(title: String, description: String, icon: String, isUnlocked: Bool) -> AppCardView {
        let card = AppCardView(
            backgroundColor: isUnlocked ? AppColors.surfacePrimary : AppColors.componentsColor,
            cornerRadius: AppCornerRadius.md,
            shadow: AppShadows.small
        )
        
        let iconLabel = UILabel()
        iconLabel.text = icon
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.alpha = isUnlocked ? 1.0 : 0.3
        
        let titleLabel = AppLabel(
            text: title,
            style: .body,
            textColor: isUnlocked ? AppColors.textPrimary : AppColors.textSecondary
        )
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 2
        
        let descriptionLabel = AppLabel(
            text: description,
            style: .caption,
            textColor: AppColors.textSecondary
        )
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        
        let stackView = UIStackView(arrangedSubviews: [iconLabel, titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = AppSpacing.xs
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: card.topAnchor, constant: AppSpacing.sm),
            stackView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: AppSpacing.sm),
            stackView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -AppSpacing.sm),
            stackView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -AppSpacing.sm)
        ])
        
        return card
    }
    
    private static func createSettingsButton(title: String, icon: String) -> AppButton {
        let button = AppButton(
            title: "\(icon) \(title)",
            isFilled: false,
            color: AppColors.primaryBlue
        )
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: AppSpacing.md, bottom: 0, right: 0)
        return button
    }
}

