//
//  LearningViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class LearningViewController: UIViewController, LearningViewModelDelegate {
    
    // MARK: - UI Components
    
    private let segmentedControl = UISegmentedControl(items: ["Материалы", "Самопроверка"])
    private let containerView = UIView()
    private let materialsView = MaterialsView()
    private let quizzesView = QuizzesView()
    
    // MARK: - Properties
    
    private let viewModel = LearningViewModel()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        title = "Обучение"
        
        setupSegmentedControl()
        setupContainerView()
        setupConstraints()
    }
    
    private func setupSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = AppColors.componentsColor
        segmentedControl.selectedSegmentTintColor = AppColors.mainAccentColor
        segmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segmentedControl.setTitleTextAttributes([.foregroundColor: AppColors.componentsTextColor], for: .normal)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        view.addSubview(segmentedControl)
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        
        containerView.addSubview(materialsView)
        containerView.addSubview(quizzesView)
        
        materialsView.isHidden = false
        quizzesView.isHidden = true
    }
    
    private func setupConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        materialsView.translatesAutoresizingMaskIntoConstraints = false
        quizzesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Segmented Control
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 50),
            
            // Container View
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            // Materials View
            materialsView.topAnchor.constraint(equalTo: containerView.topAnchor),
            materialsView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            materialsView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            materialsView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            // Quizzes View
            quizzesView.topAnchor.constraint(equalTo: containerView.topAnchor),
            quizzesView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            quizzesView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            quizzesView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    private func setupViewModel() {
        viewModel.delegate = self
        viewModel.loadMaterials()
        viewModel.loadQuizzes()
    }
    
    // MARK: - Actions
    
    @objc private func segmentChanged() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        viewModel.selectSegment(at: selectedIndex)
        
        UIView.transition(with: containerView, duration: 0.3, options: .transitionCrossDissolve) {
            if selectedIndex == 0 {
                self.materialsView.isHidden = false
                self.quizzesView.isHidden = true
            } else {
                self.materialsView.isHidden = true
                self.quizzesView.isHidden = false
            }
        }
    }
    
    // MARK: - LearningViewModelDelegate
    
    func learningViewModelDidUpdateMaterials(_ viewModel: LearningViewModel) {
        DispatchQueue.main.async {
            self.materialsView.updateMaterials(self.viewModel.materials)
        }
    }
    
    func learningViewModelDidUpdateQuizzes(_ viewModel: LearningViewModel) {
        DispatchQueue.main.async {
            self.quizzesView.updateQuizzes(self.viewModel.quizzes) { [weak self] quiz in
                self?.viewModel.startQuiz(quiz)
            }
        }
    }
    
    func learningViewModelShouldPresentQuiz(_ viewModel: LearningViewModel, quiz: Quiz) {
        DispatchQueue.main.async {
            let quizViewController = QuizViewController(quiz: quiz)
            quizViewController.delegate = self
            let navigationController = UINavigationController(rootViewController: quizViewController)
            navigationController.modalPresentationStyle = .pageSheet
            self.present(navigationController, animated: true)
        }
    }
}

// MARK: - QuizViewControllerDelegate

extension LearningViewController: QuizViewControllerDelegate {
    func quizViewControllerDidComplete(_ quizViewController: QuizViewController, quizId: String) {
        viewModel.markQuizAsCompleted(quizId)
        quizViewController.dismiss(animated: true)
    }
}

