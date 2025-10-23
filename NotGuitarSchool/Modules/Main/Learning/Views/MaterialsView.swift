//
//  MaterialsView.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class MaterialsView: UIView {
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private let titleLabel = UILabel()
    
    // MARK: - Properties
    
    private var materials: [LearningMaterial] = []
    
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
        titleLabel.text = "Материалы для повторения"
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
    
    func updateMaterials(_ materials: [LearningMaterial]) {
        self.materials = materials
        updateUI()
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        // Очищаем существующие view
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Добавляем карточки материалов
        for material in materials {
            let materialCard = createMaterialCard(for: material)
            stackView.addArrangedSubview(materialCard)
        }
    }
    
    private func createMaterialCard(for material: LearningMaterial) -> UIView {
        let cardView = UIView()
        cardView.backgroundColor = AppColors.componentsColor
        cardView.layer.cornerRadius = 12
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 4
        cardView.layer.shadowOpacity = 0.1
        
        // Заголовок
        let titleLabel = UILabel()
        titleLabel.text = material.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = AppColors.textColor
        titleLabel.numberOfLines = 0
        
        // Описание
        let descriptionLabel = UILabel()
        descriptionLabel.text = material.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = AppColors.componentsTextColor
        descriptionLabel.numberOfLines = 2
        
        // Статус
        let statusLabel = UILabel()
        statusLabel.text = material.isCompleted ? "✓ Изучено" : "📖 К изучению"
        statusLabel.font = UIFont.systemFont(ofSize: 12)
        statusLabel.textColor = material.isCompleted ? .systemGreen : AppColors.componentsTextColor
        
        // Кнопка действия
        let actionButton = AppButton(
            title: material.isCompleted ? "Повторить" : "Изучить",
            isFilled: !material.isCompleted,
            color: material.isCompleted ? .systemGreen : AppColors.mainAccentColor
        )
        actionButton.addTarget(self, action: #selector(materialButtonTapped(_:)), for: .touchUpInside)
        actionButton.tag = Int(material.id) ?? 0
        
        // Добавляем элементы в карточку
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(statusLabel)
        cardView.addSubview(actionButton)
        
        // Настройка constraints
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // Status
            statusLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            statusLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            
            // Action Button
            actionButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 12),
            actionButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            actionButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        return cardView
    }
    
    @objc private func materialButtonTapped(_ sender: UIButton) {
        let materialId = String(sender.tag)
        if let material = materials.first(where: { $0.id == materialId }) {
            // Здесь можно добавить логику для открытия детального просмотра материала
            print("Открываем материал: \(material.title)")
        }
    }
}
