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
                title: "Основы игры на гитаре",
                description: "Изучите правильную посадку, постановку рук и базовые аккорды",
                content: """
                В этом уроке вы изучите:
                • Правильную посадку и постановку рук
                • Основные аккорды: C, D, E, F, G, A, Am, Em
                • Технику перебора струн
                • Базовые упражнения для развития пальцев
                
                Время изучения: 15-20 минут
                """,
                imageName: "chord_basics",
                isCompleted: false
            ),
            LearningMaterial(
                id: "2",
                title: "Аккорды и их построение",
                description: "Углубитесь в теорию аккордов и научитесь их строить",
                content: """
                В этом уроке вы узнаете:
                • Что такое мажорные и минорные аккорды
                • Как строить аккорды от любой ноты
                • Баррэ - техника зажатия нескольких струн
                • Практические упражнения с аккордами
                
                Время изучения: 25-30 минут
                """,
                imageName: "hand_position",
                isCompleted: true
            ),
            LearningMaterial(
                id: "3",
                title: "Ритм и размеры",
                description: "Освойте различные ритмические рисунки и размеры",
                content: """
                В этом уроке вы изучите:
                • Размеры 4/4, 3/4, 2/4
                • Различные ритмические рисунки
                • Синкопа и затакт
                • Игра под метроном
                
                Время изучения: 20-25 минут
                """,
                imageName: "rhythm",
                isCompleted: false
            ),
            LearningMaterial(
                id: "4",
                title: "Техника медиатора",
                description: "Научитесь играть медиатором и освоите различные техники",
                content: """
                В этом уроке вы освоите:
                • Правильное держание медиатора
                • Технику даун-строк и ап-строк
                • Альтернативный штрих
                • Игру аккордов медиатором
                
                Время изучения: 18-22 минуты
                """,
                imageName: "pick_technique",
                isCompleted: false
            ),
            LearningMaterial(
                id: "5",
                title: "Простые песни",
                description: "Изучите несколько простых песен для практики",
                content: """
                В этом уроке вы разучите:
                • "В траве сидел кузнечик" - простая детская песня
                • "Happy Birthday" - классика для начинающих
                • "Звезда по имени Солнце" - известная композиция
                • Советы по разучиванию песен
                
                Время изучения: 30-35 минут
                """,
                imageName: "simple_songs",
                isCompleted: false
            )
        ]
        
        // Mock квизы
        quizzes = [
            Quiz(
                id: "1",
                title: "Основы игры на гитаре",
                description: "Проверьте свои знания основ игры на гитаре",
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
                    ),
                    QuizQuestion(
                        id: "3",
                        question: "Какая струна самая толстая на гитаре?",
                        options: ["1-я", "3-я", "6-я", "4-я"],
                        correctAnswerIndex: 2
                    ),
                    QuizQuestion(
                        id: "4",
                        question: "Как называется техника игры пальцами без медиатора?",
                        options: ["Фингерпикинг", "Слайдинг", "Бендинг", "Хаммер-он"],
                        correctAnswerIndex: 0
                    )
                ],
                isCompleted: false
            ),
            Quiz(
                id: "2",
                title: "Аккорды и их построение",
                description: "Тест на знание теории аккордов",
                questions: [
                    QuizQuestion(
                        id: "1",
                        question: "Что означает 4/4 в размере?",
                        options: ["4 четверти в такте", "4 восьмые в такте", "4 половинные в такте", "4 целые в такте"],
                        correctAnswerIndex: 0
                    ),
                    QuizQuestion(
                        id: "2",
                        question: "Какой аккорд является минорным?",
                        options: ["C", "D", "Am", "G"],
                        correctAnswerIndex: 2
                    ),
                    QuizQuestion(
                        id: "3",
                        question: "Что такое баррэ?",
                        options: ["Техника игры медиатором", "Зажатие нескольких струн одним пальцем", "Быстрая смена аккордов", "Игра на открытых струнах"],
                        correctAnswerIndex: 1
                    )
                ],
                isCompleted: true
            ),
            Quiz(
                id: "3",
                title: "Ритм и размеры",
                description: "Проверьте понимание ритмических основ",
                questions: [
                    QuizQuestion(
                        id: "1",
                        question: "Какой размер характерен для вальса?",
                        options: ["4/4", "3/4", "2/4", "6/8"],
                        correctAnswerIndex: 1
                    ),
                    QuizQuestion(
                        id: "2",
                        question: "Что такое синкопа?",
                        options: ["Быстрая игра", "Смещение акцента с сильной доли на слабую", "Игра в высоком темпе", "Техника легато"],
                        correctAnswerIndex: 1
                    ),
                    QuizQuestion(
                        id: "3",
                        question: "Для чего нужен метроном?",
                        options: ["Для настройки гитары", "Для поддержания ровного темпа", "Для записи музыки", "Для усиления звука"],
                        correctAnswerIndex: 1
                    )
                ],
                isCompleted: false
            ),
            Quiz(
                id: "4",
                title: "Техника медиатора",
                description: "Тест на знание техники игры медиатором",
                questions: [
                    QuizQuestion(
                        id: "1",
                        question: "Как правильно держать медиатор?",
                        options: ["Между большим и указательным пальцами", "Между указательным и средним", "Между средним и безымянным", "Между безымянным и мизинцем"],
                        correctAnswerIndex: 0
                    ),
                    QuizQuestion(
                        id: "2",
                        question: "Что такое альтернативный штрих?",
                        options: ["Игра только вниз", "Игра только вверх", "Чередование ударов вниз и вверх", "Игра с переменной силой"],
                        correctAnswerIndex: 2
                    )
                ],
                isCompleted: false
            )
        ]
    }
}
