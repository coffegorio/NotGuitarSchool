//
//  QuizViewModel.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import Foundation

protocol QuizViewModelDelegate: AnyObject {
    func quizViewModelDidUpdateQuestion(_ viewModel: QuizViewModel, question: QuizQuestion, index: Int, total: Int)
    func quizViewModelDidUpdateProgress(_ viewModel: QuizViewModel, progress: Float)
    func quizViewModelDidCompleteQuiz(_ viewModel: QuizViewModel, score: Int, total: Int)
    func quizViewModelDidUpdateNextButton(_ viewModel: QuizViewModel, isEnabled: Bool, title: String)
}

final class QuizViewModel {
    
    // MARK: - Properties
    
    weak var delegate: QuizViewModelDelegate?
    
    let quiz: Quiz
    private var currentQuestionIndex = 0
    private var selectedAnswers: [Int] = []
    private var score = 0
    private var isQuizCompleted = false
    
    // MARK: - Computed Properties
    
    var currentQuestion: QuizQuestion? {
        guard currentQuestionIndex < quiz.questions.count else { return nil }
        return quiz.questions[currentQuestionIndex]
    }
    
    var progress: Float {
        return Float(currentQuestionIndex) / Float(quiz.questions.count)
    }
    
    var isLastQuestion: Bool {
        return currentQuestionIndex == quiz.questions.count - 1
    }
    
    var nextButtonTitle: String {
        if isLastQuestion {
            return "Завершить тест"
        } else {
            return "Следующий вопрос"
        }
    }
    
    // MARK: - Initialization
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    // MARK: - Public Methods
    
    func startQuiz() {
        currentQuestionIndex = 0
        selectedAnswers.removeAll()
        score = 0
        isQuizCompleted = false
        showCurrentQuestion()
    }
    
    func selectAnswer(at index: Int) {
        // Сохраняем ответ
        if selectedAnswers.count <= currentQuestionIndex {
            selectedAnswers.append(index)
        } else {
            selectedAnswers[currentQuestionIndex] = index
        }
        
        // Уведомляем о том, что кнопка "Следующий" должна быть активна
        delegate?.quizViewModelDidUpdateNextButton(self, isEnabled: true, title: nextButtonTitle)
    }
    
    func nextQuestion() {
        if isLastQuestion {
            completeQuiz()
        } else {
            currentQuestionIndex += 1
            showCurrentQuestion()
        }
    }
    
    func retryQuiz() {
        startQuiz()
    }
    
    // MARK: - Private Methods
    
    private func showCurrentQuestion() {
        guard let question = currentQuestion else { return }
        
        // Уведомляем о новом вопросе
        delegate?.quizViewModelDidUpdateQuestion(self, question: question, index: currentQuestionIndex, total: quiz.questions.count)
        
        // Обновляем прогресс
        delegate?.quizViewModelDidUpdateProgress(self, progress: progress)
        
        // Деактивируем кнопку "Следующий вопрос"
        delegate?.quizViewModelDidUpdateNextButton(self, isEnabled: false, title: nextButtonTitle)
    }
    
    private func completeQuiz() {
        // Подсчитываем результат
        score = 0
        for (index, question) in quiz.questions.enumerated() {
            if index < selectedAnswers.count && selectedAnswers[index] == question.correctAnswerIndex {
                score += 1
            }
        }
        
        isQuizCompleted = true
        delegate?.quizViewModelDidCompleteQuiz(self, score: score, total: quiz.questions.count)
    }
}
