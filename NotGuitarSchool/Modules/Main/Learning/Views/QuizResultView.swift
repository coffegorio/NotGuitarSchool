//
//  QuizResultView.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

protocol QuizResultViewDelegate: AnyObject {
    func quizResultViewDidTapRetry(_ resultView: QuizResultView)
    func quizResultViewDidTapFinish(_ resultView: QuizResultView)
}

class QuizResultView: UIView {
    
    // MARK: - UI Components
    
    private let containerView = UIView()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let scoreLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let retryButton = AppButton(title: "Повторить", isFilled: false)
    private let finishButton = AppButton(title: "Завершить")
    
    // MARK: - Properties
    
    weak var delegate: QuizResultViewDelegate?
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = .clear
        
        setupContainerView()
        setupIconImageView()
        setupTitleLabel()
        setupScoreLabel()
        setupDescriptionLabel()
        setupRetryButton()
        setupFinishButton()
        setupConstraints()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = AppColors.componentsColor
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.1
        
        addSubview(containerView)
    }
    
    private func setupIconImageView() {
        iconImageView.contentMode = .scaleAspectFit
        containerView.addSubview(iconImageView)
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = AppColors.textColor
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        containerView.addSubview(titleLabel)
    }
    
    private func setupScoreLabel() {
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 48)
        scoreLabel.textColor = AppColors.mainAccentColor
        scoreLabel.textAlignment = .center
        
        containerView.addSubview(scoreLabel)
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = AppColors.componentsTextColor
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        containerView.addSubview(descriptionLabel)
    }
    
    private func setupRetryButton() {
        retryButton.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        containerView.addSubview(retryButton)
    }
    
    private func setupFinishButton() {
        finishButton.addTarget(self, action: #selector(finishButtonTapped), for: .touchUpInside)
        containerView.addSubview(finishButton)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Icon
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 80),
            iconImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            // Score
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scoreLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            scoreLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            // Retry Button
            retryButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 32),
            retryButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            retryButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            retryButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Finish Button
            finishButton.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 12),
            finishButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            finishButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            finishButton.heightAnchor.constraint(equalToConstant: 50),
            finishButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func retryButtonTapped() {
        delegate?.quizResultViewDidTapRetry(self)
    }
    
    @objc private func finishButtonTapped() {
        delegate?.quizResultViewDidTapFinish(self)
    }
    
    // MARK: - Public Methods
    
    func showResult(score: Int, total: Int) {
        let percentage = (score * 100) / total
        
        // Настраиваем иконку и заголовок в зависимости от результата
        if percentage >= 80 {
            iconImageView.image = UIImage(systemName: "star.fill")
            iconImageView.tintColor = .systemYellow
            titleLabel.text = "Отлично!"
            titleLabel.textColor = .systemGreen
        } else if percentage >= 60 {
            iconImageView.image = UIImage(systemName: "checkmark.circle.fill")
            iconImageView.tintColor = .systemGreen
            titleLabel.text = "Хорошо!"
            titleLabel.textColor = .systemGreen
        } else {
            iconImageView.image = UIImage(systemName: "exclamationmark.triangle.fill")
            iconImageView.tintColor = .systemOrange
            titleLabel.text = "Попробуйте еще раз"
            titleLabel.textColor = .systemOrange
        }
        
        // Показываем результат
        scoreLabel.text = "\(score)/\(total)"
        descriptionLabel.text = "Вы ответили правильно на \(score) из \(total) вопросов"
        
        // Анимация появления
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseOut],
                       animations: {
            self.containerView.alpha = 1.0
            self.containerView.transform = .identity
        })
    }
}
