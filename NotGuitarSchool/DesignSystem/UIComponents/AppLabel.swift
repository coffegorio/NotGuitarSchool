//
//  AppLabel.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

final class AppLabel: UILabel {
    
    enum Style {
        case greetings      // Большой жирный заголовок
        case headline       // Средний заголовок
        case body           // Обычный текст
        case caption        // Мелкий текст
    }
    
    // MARK: - Инициализация
    
    init(text: String = "",
         style: Style = .body,
         textColor: UIColor? = nil,
         numberOfLines: Int = 0) {
        
        super.init(frame: .zero)
        
        self.text = text
        self.numberOfLines = numberOfLines
        self.translatesAutoresizingMaskIntoConstraints = false
        
        applyStyle(style: style)
        
        if let customColor = textColor {
            self.textColor = customColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        applyStyle(style: .body)
    }
    
    // MARK: - Настройка стиля
    
    private func applyStyle(style: Style) {
        switch style {
        case .greetings:
            font = UIFont.systemFont(ofSize: AppTypography.largeTitle, weight: AppTypography.bold)
            textColor = AppColors.textPrimary
            lineBreakMode = .byWordWrapping
            textAlignment = .left
        case .headline:
            font = UIFont.systemFont(ofSize: AppTypography.title2, weight: AppTypography.semibold)
            textColor = AppColors.textPrimary
            lineBreakMode = .byWordWrapping
            textAlignment = .left
        case .body:
            font = UIFont.systemFont(ofSize: AppTypography.body, weight: AppTypography.regular)
            textColor = AppColors.textPrimary
            lineBreakMode = .byWordWrapping
            textAlignment = .left
        case .caption:
            font = UIFont.systemFont(ofSize: AppTypography.caption1, weight: AppTypography.medium)
            textColor = AppColors.textSecondary
            lineBreakMode = .byTruncatingTail
            textAlignment = .left
        }
    }
}

