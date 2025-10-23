//
//  DesignSystem.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

// MARK: - App Colors

struct AppColors {
    // Primary Colors
    static let backgroundColor = UIColor(named: "BackgroundColor") ?? UIColor.systemBackground
    static let textColor = UIColor(named: "TextColor") ?? UIColor.label
    static let mainAccentColor = UIColor(named: "MainAccentColor") ?? UIColor.systemBlue
    static let componentsColor = UIColor(named: "ComponentsColor") ?? UIColor.systemGray6
    static let componentsTextColor = UIColor(named: "ComponentsTextColor") ?? UIColor.label
    
    // Extended Color Palette
    static let primaryBlue = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 1.0)
    static let primaryBlueLight = UIColor(red: 0.0, green: 0.48, blue: 1.0, alpha: 0.1)
    static let secondaryGreen = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1.0)
    static let secondaryGreenLight = UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 0.1)
    static let accentOrange = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 1.0)
    static let accentOrangeLight = UIColor(red: 1.0, green: 0.58, blue: 0.0, alpha: 0.1)
    static let warningRed = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
    static let warningRedLight = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 0.1)
    
    // Surface Colors
    static let surfacePrimary = UIColor.systemBackground
    static let surfaceSecondary = UIColor.secondarySystemBackground
    static let surfaceTertiary = UIColor.tertiarySystemBackground
    
    // Text Colors
    static let textPrimary = UIColor.label
    static let textSecondary = UIColor.secondaryLabel
    static let textTertiary = UIColor.tertiaryLabel
    static let textInverse = UIColor.white
    
    // Border Colors
    static let borderPrimary = UIColor.separator
    static let borderSecondary = UIColor.opaqueSeparator
}

// MARK: - App Typography

struct AppTypography {
    // Font Sizes
    static let largeTitle: CGFloat = 34
    static let title1: CGFloat = 28
    static let title2: CGFloat = 22
    static let title3: CGFloat = 20
    static let headline: CGFloat = 17
    static let body: CGFloat = 17
    static let callout: CGFloat = 16
    static let subhead: CGFloat = 15
    static let footnote: CGFloat = 13
    static let caption1: CGFloat = 12
    static let caption2: CGFloat = 11
    
    // Font Weights
    static let ultraLight = UIFont.Weight.ultraLight
    static let thin = UIFont.Weight.thin
    static let light = UIFont.Weight.light
    static let regular = UIFont.Weight.regular
    static let medium = UIFont.Weight.medium
    static let semibold = UIFont.Weight.semibold
    static let bold = UIFont.Weight.bold
    static let heavy = UIFont.Weight.heavy
    static let black = UIFont.Weight.black
}

// MARK: - App Spacing

struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}

// MARK: - App Corner Radius

struct AppCornerRadius {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 12
    static let lg: CGFloat = 16
    static let xl: CGFloat = 20
    static let xxl: CGFloat = 24
    static let round: CGFloat = 50
}

// MARK: - App Shadows

struct AppShadows {
    static let small = Shadow(
        color: UIColor.black.withAlphaComponent(0.1),
        offset: CGSize(width: 0, height: 1),
        radius: 2,
        opacity: 1.0
    )
    
    static let medium = Shadow(
        color: UIColor.black.withAlphaComponent(0.1),
        offset: CGSize(width: 0, height: 2),
        radius: 4,
        opacity: 1.0
    )
    
    static let large = Shadow(
        color: UIColor.black.withAlphaComponent(0.15),
        offset: CGSize(width: 0, height: 4),
        radius: 8,
        opacity: 1.0
    )
    
    static let extraLarge = Shadow(
        color: UIColor.black.withAlphaComponent(0.2),
        offset: CGSize(width: 0, height: 8),
        radius: 16,
        opacity: 1.0
    )
}

struct Shadow {
    let color: UIColor
    let offset: CGSize
    let radius: CGFloat
    let opacity: Float
}

// MARK: - App Gradients

struct AppGradients {
    static let primary = Gradient(
        colors: [AppColors.primaryBlue, AppColors.primaryBlue.withAlphaComponent(0.8)],
        startPoint: CGPoint(x: 0, y: 0),
        endPoint: CGPoint(x: 1, y: 1)
    )
    
    static let success = Gradient(
        colors: [AppColors.secondaryGreen, AppColors.secondaryGreen.withAlphaComponent(0.8)],
        startPoint: CGPoint(x: 0, y: 0),
        endPoint: CGPoint(x: 1, y: 1)
    )
    
    static let warning = Gradient(
        colors: [AppColors.accentOrange, AppColors.accentOrange.withAlphaComponent(0.8)],
        startPoint: CGPoint(x: 0, y: 0),
        endPoint: CGPoint(x: 1, y: 1)
    )
    
    static let error = Gradient(
        colors: [AppColors.warningRed, AppColors.warningRed.withAlphaComponent(0.8)],
        startPoint: CGPoint(x: 0, y: 0),
        endPoint: CGPoint(x: 1, y: 1)
    )
}

struct Gradient {
    let colors: [UIColor]
    let startPoint: CGPoint
    let endPoint: CGPoint
}


