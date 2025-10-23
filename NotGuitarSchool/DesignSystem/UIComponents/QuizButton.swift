//
//  QuizButton.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

final class QuizButton: UIButton {
    
    // MARK: - Properties
    
    private let quiz: Quiz
    private let iconImageView = UIImageView()
    private let customTitleLabel = UILabel()
    private let customSubtitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    
    // MARK: - Initialization
    
    init(quiz: Quiz) {
        self.quiz = quiz
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        backgroundColor = quiz.isCompleted ? .systemGreen.withAlphaComponent(0.1) : AppColors.componentsColor
        layer.cornerRadius = 12
        layer.borderWidth = 2
        layer.borderColor = quiz.isCompleted ? UIColor.systemGreen.cgColor : AppColors.mainAccentColor.cgColor
        
        setupIconImageView()
        setupTitleLabel()
        setupSubtitleLabel()
        setupArrowImageView()
        setupConstraints()
        setupAnimations()
    }
    
    private func setupIconImageView() {
        iconImageView.image = UIImage(systemName: quiz.isCompleted ? "checkmark.circle.fill" : "play.circle.fill")
        iconImageView.tintColor = quiz.isCompleted ? .systemGreen : AppColors.mainAccentColor
        iconImageView.contentMode = .scaleAspectFit
        
        addSubview(iconImageView)
    }
    
    private func setupTitleLabel() {
        customTitleLabel.text = quiz.isCompleted ? "Повторить тест" : "Начать тест"
        customTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        customTitleLabel.textColor = quiz.isCompleted ? .systemGreen : AppColors.mainAccentColor
        customTitleLabel.textAlignment = .left
        
        addSubview(customTitleLabel)
    }
    
    private func setupSubtitleLabel() {
        customSubtitleLabel.text = "\(quiz.questions.count) \(checkQuestionCount())"
        customSubtitleLabel.font = UIFont.systemFont(ofSize: 12)
        customSubtitleLabel.textColor = AppColors.componentsTextColor
        customSubtitleLabel.textAlignment = .left
        
        addSubview(customSubtitleLabel)
    }
    
    private func checkQuestionCount() -> String {
        if quiz.questions.count == 1 {
            return "вопрос"
        } else {
            return "вопросов"
        }
    }
    
    private func setupArrowImageView() {
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = quiz.isCompleted ? .systemGreen : AppColors.mainAccentColor
        arrowImageView.contentMode = .scaleAspectFit
        
        addSubview(arrowImageView)
    }
    
    private func setupConstraints() {
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        customSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Icon
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            // Title
            customTitleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            customTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            customTitleLabel.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -8),
            
            // Subtitle
            customSubtitleLabel.leadingAnchor.constraint(equalTo: customTitleLabel.leadingAnchor),
            customSubtitleLabel.topAnchor.constraint(equalTo: customTitleLabel.bottomAnchor, constant: 2),
            customSubtitleLabel.trailingAnchor.constraint(equalTo: customTitleLabel.trailingAnchor),
            customSubtitleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            // Arrow
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setupAnimations() {
        addTarget(self, action: #selector(animatePress), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateRelease), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    // MARK: - Animations
    
    @objc private func animatePress() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }, completion: nil)
    }
    
    @objc private func animateRelease() {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseOut],
                       animations: {
            self.transform = .identity
            self.alpha = 1.0
        }, completion: nil)
    }
    
    // MARK: - Public Methods
    
    func updateQuiz(_ quiz: Quiz) {
        // Обновляем UI при изменении статуса квиза
        DispatchQueue.main.async {
            self.setupUI()
        }
    }
}
