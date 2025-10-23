//
//  AppCardView.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit

final class AppCardView: UIView {
    
    // MARK: - Properties
    
    private let shadow: Shadow
    private let cornerRadius: CGFloat
    private let cardBackgroundColor: UIColor
    
    // MARK: - Initialization
    
    init(
        backgroundColor: UIColor = AppColors.surfacePrimary,
        cornerRadius: CGFloat = AppCornerRadius.lg,
        shadow: Shadow = AppShadows.medium
    ) {
        self.cardBackgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.cardBackgroundColor = AppColors.surfacePrimary
        self.cornerRadius = AppCornerRadius.lg
        self.shadow = AppShadows.medium
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = cardBackgroundColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Apply shadow
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = shadow.opacity
    }
    
    // MARK: - Public Methods
    
    func updateShadow(_ newShadow: Shadow) {
        layer.shadowColor = newShadow.color.cgColor
        layer.shadowOffset = newShadow.offset
        layer.shadowRadius = newShadow.radius
        layer.shadowOpacity = newShadow.opacity
    }
    
    func updateCornerRadius(_ newRadius: CGFloat) {
        layer.cornerRadius = newRadius
    }
    
    func updateBackgroundColor(_ newColor: UIColor) {
        backgroundColor = newColor
    }
}

// MARK: - Gradient Card View

final class AppGradientCardView: UIView {
    
    // MARK: - Properties
    
    private let gradient: Gradient
    private let cornerRadius: CGFloat
    private let shadow: Shadow
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - Initialization
    
    init(
        gradient: Gradient = AppGradients.primary,
        cornerRadius: CGFloat = AppCornerRadius.lg,
        shadow: Shadow = AppShadows.medium
    ) {
        self.gradient = gradient
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.gradient = AppGradients.primary
        self.cornerRadius = AppCornerRadius.lg
        self.shadow = AppShadows.medium
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        
        // Apply shadow
        layer.shadowColor = shadow.color.cgColor
        layer.shadowOffset = shadow.offset
        layer.shadowRadius = shadow.radius
        layer.shadowOpacity = shadow.opacity
        
        // Setup gradient
        setupGradient()
    }
    
    private func setupGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradient.colors.map { $0.cgColor }
        gradientLayer.startPoint = gradient.startPoint
        gradientLayer.endPoint = gradient.endPoint
        gradientLayer.cornerRadius = cornerRadius
        
        layer.insertSublayer(gradientLayer, at: 0)
        self.gradientLayer = gradientLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // MARK: - Public Methods
    
    func updateGradient(_ newGradient: Gradient) {
        gradientLayer?.colors = newGradient.colors.map { $0.cgColor }
        gradientLayer?.startPoint = newGradient.startPoint
        gradientLayer?.endPoint = newGradient.endPoint
    }
    
    func updateShadow(_ newShadow: Shadow) {
        layer.shadowColor = newShadow.color.cgColor
        layer.shadowOffset = newShadow.offset
        layer.shadowRadius = newShadow.radius
        layer.shadowOpacity = newShadow.opacity
    }
}
