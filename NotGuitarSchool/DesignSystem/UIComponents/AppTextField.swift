//
//  AppTextField.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

final class AppTextField: UITextField {
    
    // MARK: - Параметры
    
    private var fieldColor: UIColor = .systemBlue
    private var isFilled: Bool = true
    
    // MARK: - Инициализация
    
    init(placeholder: String = "Введите текст",
         isFilled: Bool = true,
         color: UIColor = .systemBlue) {
        super.init(frame: .zero)
        
        self.isFilled = isFilled
        self.fieldColor = color
        
        setupUI(placeholder: placeholder)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI(placeholder: "Введите текст")
    }
    
    // MARK: - Настройка
    
    private func setupUI(placeholder: String) {
        self.placeholder = placeholder
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = UIFont.systemFont(ofSize: AppTypography.body, weight: AppTypography.regular)
        self.textColor = AppColors.textPrimary
        self.textAlignment = .left
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.clearButtonMode = .whileEditing
        self.layer.cornerRadius = AppCornerRadius.md
        self.clipsToBounds = true
        self.setPadding(left: AppSpacing.md, right: AppSpacing.md)
        
        if isFilled {
            self.backgroundColor = fieldColor.withAlphaComponent(0.1)
            self.layer.borderWidth = 0
        } else {
            self.backgroundColor = .clear
            self.layer.borderWidth = 2
            self.layer.borderColor = fieldColor.cgColor
        }
        
        // Анимация на фокус
        self.addTarget(self, action: #selector(didBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(didEndEditing), for: .editingDidEnd)
    }
    
    // MARK: - Анимация
    
    @objc private func didBeginEditing() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderColor = self.fieldColor.cgColor
            self.layer.borderWidth = 2
        }
    }
    
    @objc private func didEndEditing() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = self.isFilled ? 0 : 2
            self.layer.borderColor = self.isFilled ? UIColor.clear.cgColor : self.fieldColor.cgColor
        }
    }
    
    // MARK: - Padding
    
    private func setPadding(left: CGFloat, right: CGFloat) {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.height))
        self.leftView = leftView
        self.leftViewMode = .always
        
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: right, height: frame.height))
        self.rightView = rightView
        self.rightViewMode = .always
    }
}

