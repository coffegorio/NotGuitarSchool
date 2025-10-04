//
//  LearningViewModel.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import Foundation

protocol LearningViewModelDelegate: AnyObject {
    func learningViewModelDidUpdateMaterials(_ viewModel: LearningViewModel)
    func learningViewModelDidUpdateQuizzes(_ viewModel: LearningViewModel)
    func learningViewModelShouldPresentQuiz(_ viewModel: LearningViewModel, quiz: Quiz)
}

// MARK: - Models

struct LearningMaterial {
    let id: String
    let title: String
    let description: String
    let content: String
    let imageName: String?
    let isCompleted: Bool
}

struct Quiz {
    let id: String
    let title: String
    let description: String
    let questions: [QuizQuestion]
    let isCompleted: Bool
}

struct QuizQuestion {
    let id: String
    let question: String
    let options: [String]
    let correctAnswerIndex: Int
}

// MARK: - LearningViewModel

final class LearningViewModel {
    weak var delegate: LearningViewModelDelegate?
    
    // MARK: - Properties
    
    private(set) var materials: [LearningMaterial] = []
    private(set) var quizzes: [Quiz] = []
    private(set) var selectedSegmentIndex: Int = 0
    
    // MARK: - Initialization
    
    init() {
        loadMockData()
    }
    
    // MARK: - Public Methods
    
    func selectSegment(at index: Int) {
        selectedSegmentIndex = index
    }
    
    func loadMaterials() {
        // В реальном приложении здесь будет загрузка из сети или базы данных
        delegate?.learningViewModelDidUpdateMaterials(self)
    }
    
    func loadQuizzes() {
        // В реальном приложении здесь будет загрузка из сети или базы данных
        delegate?.learningViewModelDidUpdateQuizzes(self)
    }
    
    func startQuiz(_ quiz: Quiz) {
        delegate?.learningViewModelShouldPresentQuiz(self, quiz: quiz)
    }
    
    func markMaterialAsCompleted(_ materialId: String) {
        if let index = materials.firstIndex(where: { $0.id == materialId }) {
            let material = materials[index]
            let updatedMaterial = LearningMaterial(
                id: material.id,
                title: material.title,
                description: material.description,
                content: material.content,
                imageName: material.imageName,
                isCompleted: true
            )
            materials[index] = updatedMaterial
            delegate?.learningViewModelDidUpdateMaterials(self)
        }
    }
    
    func markQuizAsCompleted(_ quizId: String) {
        if let index = quizzes.firstIndex(where: { $0.id == quizId }) {
            let quiz = quizzes[index]
            let updatedQuiz = Quiz(
                id: quiz.id,
                title: quiz.title,
                description: quiz.description,
                questions: quiz.questions,
                isCompleted: true
            )
            quizzes[index] = updatedQuiz
            delegate?.learningViewModelDidUpdateQuizzes(self)
        }
    }
    
    // MARK: - Private Methods
    
    private func loadMockData() {
        // Mock материалы
        materials = [
            LearningMaterial(
                id: "1",
                title: "Урок №1",
                description: "Повторите материалы первого урока!",
                content: "В этом уроке мы изучим основные аккорды: C, D, E, F, G, A, B...",
                imageName: "chord_basics",
                isCompleted: false
            ),
            LearningMaterial(
                id: "2",
                title: "Урок №2",
                description: "Повторите материалы второго гитарного урока!",
                content: "Правильная постановка рук - основа качественной игры...",
                imageName: "hand_position",
                isCompleted: true
            ),
            LearningMaterial(
                id: "3",
                title: "Урок №3",
                description: "Повторите и закрепите все, что было на третьем гитарном уроке!",
                content: "Ритм - это основа музыки. В этом уроке мы разберем...",
                imageName: "rhythm",
                isCompleted: false
            )
        ]
        
        // Mock квизы
        quizzes = [
            Quiz(
                id: "1",
                title: "Тест по уроку №1",
                description: "Пройдите тест по уроку №1 для закрепления всего, что было на занятии!",
                questions: [
                    QuizQuestion(
                        id: "1",
                        question: "Какой аккорд состоит из нот C, E, G?",
                        options: ["C", "D", "E", "F"],
                        correctAnswerIndex: 0
                    ),
                    QuizQuestion(
                        id: "2",
                        question: "Сколько пальцев используется для аккорда Am?",
                        options: ["2", "3", "4", "5"],
                        correctAnswerIndex: 1
                    )
                ],
                isCompleted: false
            ),
            Quiz(
                id: "2",
                title: "Тест по уроку №2",
                description: "Пройдите тест по уроку №2 для закрепления всего, что было на занятии!",
                questions: [
                    QuizQuestion(
                        id: "1",
                        question: "Что означает 4/4 в размере?",
                        options: ["4 четверти в такте", "4 восьмые в такте", "4 половинные в такте", "4 целые в такте"],
                        correctAnswerIndex: 0
                    )
                ],
                isCompleted: true
            )
        ]
    }
}
