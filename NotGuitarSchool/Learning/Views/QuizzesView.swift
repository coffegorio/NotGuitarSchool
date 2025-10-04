//
//  QuizzesView.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class QuizzesView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    // MARK: - Properties
    
    private var quizzes: [Quiz] = []
    private var onQuizSelected: ((Quiz) -> Void)?
    
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
        
        setupTitleLabel()
        setupScrollView()
        setupStackView()
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Самопроверка"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = AppColors.textColor
        titleLabel.textAlignment = .left
        
        addSubview(titleLabel)
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        addSubview(scrollView)
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fill
        
        scrollView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Stack View
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
        ])
    }
    
    // MARK: - Public Methods
    
    func updateQuizzes(_ quizzes: [Quiz], onQuizSelected: @escaping (Quiz) -> Void) {
        self.quizzes = quizzes
        self.onQuizSelected = onQuizSelected
        updateUI()
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        // Очищаем существующие view
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем карточки квизов
        for quiz in quizzes {
            let quizCard = createQuizCard(for: quiz)
            stackView.addArrangedSubview(quizCard)
        }
    }
    
    private func createQuizCard(for quiz: Quiz) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = AppColors.componentsColor
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOpacity = 0.1
        
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = quiz.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.textColor
        titleLabel.numberOfLines = 0
        
        // Описание
        let descriptionLabel = UILabel()
        descriptionLabel.text = quiz.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = AppColors.componentsTextColor
        descriptionLabel.numberOfLines = 2
        
        // Количество вопросов
        let questionsCountLabel = UILabel()
        questionsCountLabel.text = "\(quiz.questions.count) вопросов"
        questionsCountLabel.font = UIFont.systemFont(ofSize: 12)
        questionsCountLabel.textColor = AppColors.componentsTextColor
        
        // Статус
        let statusLabel = UILabel()
        statusLabel.text = quiz.isCompleted ? "✓ Пройден" : "📝 К прохождению"
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = quiz.isCompleted ? .systemGreen : AppColors.componentsTextColor
        
        // Кнопка квиза
        let quizButton = QuizButton(quiz: quiz)
        quizButton.addTarget(self, action: #selector(quizButtonTapped(_:)), for: .touchUpInside)
        quizButton.tag = Int(quiz.id) ?? 0
        
        // Добавляем элементы в карточку
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(questionsCountLabel)
        cardView.addSubview(statusLabel)
        cardView.addSubview(quizButton)
        
        // Настройка constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionsCountLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        quizButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Questions Count
            questionsCountLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            questionsCountLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Status
            statusLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            statusLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Quiz Button
            quizButton.topAnchor.constraint(equalTo: questionsCountLabel.bottomAnchor, constant: 12),
            quizButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            quizButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            quizButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            quizButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        return cardView
    }
    
    @objc private func quizButtonTapped(_ sender: UIButton) {
        let quizId = String(sender.tag)
        if let quiz = quizzes.first(where: { $0.id == quizId }) {
            onQuizSelected?(quiz)
        }
    }
}
