//
//  AppGradientButton.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit

final class AppGradientButton: UIButton {
    
    // MARK: - Properties
    
    private let gradient: Gradient
    private let cornerRadius: CGFloat
    private var gradientLayer: CAGradientLayer?
    private var originalTransform: CGAffineTransform = .identity
    
    // MARK: - Initialization
    
    init(
        title: String = "Кнопка",
        gradient: Gradient = AppGradients.primary,
        cornerRadius: CGFloat = AppCornerRadius.md
    ) {
        self.gradient = gradient
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        setup(title: title)
    }
    
    required init?(coder: NSCoder) {
        self.gradient = AppGradients.primary
        self.cornerRadius = AppCornerRadius.md
        super.init(coder: coder)
        setup(title: "Кнопка")
    }
    
    // MARK: - Setup
    
    private func setup(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: AppTypography.headline, weight: AppTypography.semibold)
        setTitleColor(AppColors.textInverse, for: .normal)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        
        setupGradient()
        setupAnimations()
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
    
    private func setupAnimations() {
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel, .touchDragExit])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer?.frame = bounds
    }
    
    // MARK: - Animations
    
    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.alpha = 0.8
        })
    }
    
    @objc private func touchUp() {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.8, options: [.curveEaseOut], animations: {
            self.transform = .identity
            self.alpha = 1.0
        })
    }
    
    // MARK: - Public Methods
    
    func updateGradient(_ newGradient: Gradient) {
        gradientLayer?.colors = newGradient.colors.map { $0.cgColor }
        gradientLayer?.startPoint = newGradient.startPoint
        gradientLayer?.endPoint = newGradient.endPoint
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.color = AppColors.textInverse
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.tag = 999
            
            addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
            
            activityIndicator.startAnimating()
            setTitle("", for: .normal)
            isEnabled = false
        } else {
            if let activityIndicator = viewWithTag(999) as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
            setTitle("Кнопка", for: .normal)
            isEnabled = true
        }
    }
}
