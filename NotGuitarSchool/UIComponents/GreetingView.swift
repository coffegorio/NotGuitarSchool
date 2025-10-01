//
//  GreetingView.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit

final class GreetingView: UIView {
    
    // MARK: - Subviews
    
    private let greetingLabel = AppLabel(text: "", style: .greetings)
    private let subtitleLabel = AppLabel(text: "Добро пожаловать в Не школу гитары!", style: .body, textColor: AppColors.componentsTextColor, numberOfLines: 0)
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        
        let stack = UIStackView(arrangedSubviews: [greetingLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateGreeting()
    }
    
    // MARK: - Public
    
    func updateGreeting(date: Date = Date(), calendar: Calendar = .current) {
        greetingLabel.text = GreetingView.makeGreetingText(for: date, calendar: calendar)
    }
    
    // MARK: - Helpers
    
    static func makeGreetingText(for date: Date, calendar: Calendar = .current) -> String {
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 5..<12:
            return "Доброе утро!"
        case 12..<17:
            return "Добрый день!"
        case 17..<23:
            return "Добрый вечер!"
        case 23..<6:
            return "Доброй ночи!"
        default:
            return "Приветствую!"
        }
    }
}


