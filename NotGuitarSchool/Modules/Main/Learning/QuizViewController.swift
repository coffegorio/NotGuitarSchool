//
//  QuizViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

protocol QuizViewControllerDelegate: AnyObject {
    func quizViewControllerDidComplete(_ quizViewController: QuizViewController, quizId: String)
}

class QuizViewController: UIViewController, QuizViewModelDelegate {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let progressView = UIProgressView()
    private let questionLabel = UILabel()
    private let optionsStackView = UIStackView()
    private let nextButton = AppButton(title: "Следующий вопрос")
    private let resultView = QuizResultView()
    
    // MARK: - Properties
    
    private let viewModel: QuizViewModel
    private var currentSelectedAnswerIndex: Int?
    
    weak var delegate: QuizViewControllerDelegate?
    
    // MARK: - Initialization
    
    init(quiz: Quiz) {
        self.viewModel = QuizViewModel(quiz: quiz)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupViewModel()
        viewModel.startQuiz()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        
        setupScrollView()
        setupContentView()
        setupProgressView()
        setupQuestionLabel()
        setupOptionsStackView()
        setupNextButton()
        setupResultView()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        title = viewModel.quiz.title
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
    }
    
    private func setupScrollView() {
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
    }
    
    private func setupContentView() {
        scrollView.addSubview(contentView)
    }
    
    private func setupProgressView() {
        progressView.progressTintColor = AppColors.mainAccentColor
        progressView.trackTintColor = AppColors.componentsColor
        progressView.layer.cornerRadius = 4
        progressView.clipsToBounds = true
        
        contentView.addSubview(progressView)
    }
    
    private func setupQuestionLabel() {
        questionLabel.font = UIFont.boldSystemFont(ofSize: 18)
        questionLabel.textColor = AppColors.textColor
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .left
        
        contentView.addSubview(questionLabel)
    }
    
    private func setupOptionsStackView() {
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.alignment = .fill
        optionsStackView.distribution = .fill
        
        contentView.addSubview(optionsStackView)
    }
    
    private func setupNextButton() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        contentView.addSubview(nextButton)
    }
    
    private func setupResultView() {
        resultView.isHidden = true
        resultView.delegate = self
        contentView.addSubview(resultView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        resultView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Progress View
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            // Question Label
            questionLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 24),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Options Stack View
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24),
            optionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Next Button
            nextButton.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 24),
            nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            // Result View
            resultView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 24),
            resultView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            resultView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            resultView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextQuestion()
    }
    
    @objc private func optionButtonTapped(_ sender: UIButton) {
        let selectedIndex = sender.tag
        currentSelectedAnswerIndex = selectedIndex
        
        // Сбрасываем предыдущий выбор
        for subview in optionsStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.backgroundColor = AppColors.componentsColor
                button.setTitleColor(AppColors.textColor, for: .normal)
            }
        }
        
        sender.backgroundColor = AppColors.mainAccentColor
        sender.setTitleColor(.white, for: .normal)
        
        viewModel.selectAnswer(at: selectedIndex)
    }
    
    // MARK: - Private Methods
    
    private func createOptionButton(text: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .left
        button.contentHorizontalAlignment = .left
        
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
            config.title = text
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.systemFont(ofSize: 16)
                return outgoing
            }
            button.configuration = config
        } else {
            button.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        button.backgroundColor = AppColors.componentsColor
        button.setTitleColor(AppColors.textColor, for: .normal)
        button.layer.cornerRadius = 12
        button.tag = tag
        
        button.addTarget(self, action: #selector(optionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    // MARK: - QuizViewModelDelegate
    
    func quizViewModelDidUpdateQuestion(_ viewModel: QuizViewModel, question: QuizQuestion, index: Int, total: Int) {
        DispatchQueue.main.async {
            // Обновляем вопрос
            self.questionLabel.text = question.question
            
            // Очищаем предыдущие варианты
            self.optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            
            // Добавляем варианты ответов
            for (optionIndex, option) in question.options.enumerated() {
                let optionButton = self.createOptionButton(text: option, tag: optionIndex)
                self.optionsStackView.addArrangedSubview(optionButton)
            }
        }
    }
    
    func quizViewModelDidUpdateProgress(_ viewModel: QuizViewModel, progress: Float) {
        DispatchQueue.main.async {
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    func quizViewModelDidCompleteQuiz(_ viewModel: QuizViewModel, score: Int, total: Int) {
        DispatchQueue.main.async {
            // Скрываем элементы вопроса
            self.questionLabel.isHidden = true
            self.optionsStackView.isHidden = true
            self.nextButton.isHidden = true
            
            // Показываем результат
            self.resultView.isHidden = false
            self.resultView.showResult(score: score, total: total)
        }
    }
    
    func quizViewModelDidUpdateNextButton(_ viewModel: QuizViewModel, isEnabled: Bool, title: String) {
        DispatchQueue.main.async {
            self.nextButton.isEnabled = isEnabled
            self.nextButton.alpha = isEnabled ? 1.0 : 0.5
            self.nextButton.setTitle(title, for: .normal)
        }
    }
}

// MARK: - QuizResultViewDelegate

extension QuizViewController: QuizResultViewDelegate {
    func quizResultViewDidTapRetry(_ resultView: QuizResultView) {
        // Скрываем результат и показываем элементы вопроса
        resultView.isHidden = true
        questionLabel.isHidden = false
        optionsStackView.isHidden = false
        nextButton.isHidden = false
        
        // Перезапускаем квиз через ViewModel
        viewModel.retryQuiz()
    }
    
    func quizResultViewDidTapFinish(_ resultView: QuizResultView) {
        delegate?.quizViewControllerDidComplete(self, quizId: viewModel.quiz.id)
    }
}
