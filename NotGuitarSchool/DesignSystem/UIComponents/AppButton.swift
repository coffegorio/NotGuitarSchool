//
//  AppButton.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

final class AppButton: UIButton {

    // MARK: - Параметры кнопки
    
    private var isFilled: Bool = true
    private var buttonColor: UIColor = AppColors.mainAccentColor

    // MARK: - Инициализация
    
    init(title: String = "Кнопка",
         isFilled: Bool = true,
         color: UIColor = AppColors.mainAccentColor) {
        
        super.init(frame: .zero)
        
        self.isFilled = isFilled
        self.buttonColor = color
        
        setup(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup(title: "Кнопка")
    }
    
    // MARK: - Настройка кнопки
    
    private func setup(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        layer.cornerRadius = 12
        clipsToBounds = true
        
        updateStyle()
        
        addTarget(self, action: #selector(animatePress), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(animateRelease), for: [.touchUpInside, .touchCancel, .touchDragExit])
    }
    
    private func updateStyle() {
        if isFilled {
            backgroundColor = buttonColor
            setTitleColor(.white, for: .normal)
            layer.borderWidth = 0
        } else {
            backgroundColor = .clear
            setTitleColor(buttonColor, for: .normal)
            layer.borderColor = buttonColor.cgColor
            layer.borderWidth = 2
        }
    }
    
    // MARK: - Анимация
    
    @objc private func animatePress() {
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        }, completion: nil)
    }
    
    @objc private func animateRelease() {
        UIView.animate(withDuration: 0.15,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseOut],
                       animations: {
            self.transform = .identity
            self.alpha = 1.0
        }, completion: nil)
    }
}
