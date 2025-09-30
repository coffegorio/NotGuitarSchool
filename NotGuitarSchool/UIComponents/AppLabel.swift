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
            font = UIFont.systemFont(ofSize: 32, weight: .bold)
            textColor = AppColors.textColor
            lineBreakMode = .byWordWrapping
            textAlignment = .left
        case .headline:
            font = UIFont.systemFont(ofSize: 24, weight: .semibold)
            textColor = AppColors.textColor
            lineBreakMode = .byWordWrapping
            textAlignment = .left
        case .body:
            font = UIFont.systemFont(ofSize: 16)
            textColor = AppColors.textColor
            lineBreakMode = .byWordWrapping
            textAlignment = .left
        case .caption:
            font = UIFont.systemFont(ofSize: 12)
            textColor = .secondaryLabel
            lineBreakMode = .byTruncatingTail
            textAlignment = .left
        }
    }
}

