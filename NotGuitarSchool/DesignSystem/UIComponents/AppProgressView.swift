//
//  AppProgressView.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit

final class AppProgressView: UIView {
    
    // MARK: - Properties
    
    private let progressBar = UIView()
    private let backgroundBar = UIView()
    private let progressLabel = UILabel()
    private var progressLayer: CAGradientLayer?
    
    private var _progress: Float = 0.0
    var progress: Float {
        get { return _progress }
        set {
            _progress = max(0.0, min(1.0, newValue))
            updateProgress()
        }
    }
    
    private var _progressColor: UIColor = AppColors.primaryBlue
    var progressColor: UIColor {
        get { return _progressColor }
        set {
            _progressColor = newValue
            updateProgressColor()
        }
    }
    
    private var _showPercentage: Bool = true
    var showPercentage: Bool {
        get { return _showPercentage }
        set {
            _showPercentage = newValue
            progressLabel.isHidden = !newValue
        }
    }
    
    // MARK: - Initialization
    
    init(
        progress: Float = 0.0,
        progressColor: UIColor = AppColors.primaryBlue,
        showPercentage: Bool = true
    ) {
        self._progress = progress
        self._progressColor = progressColor
        self._showPercentage = showPercentage
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Setup
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        
        setupBackgroundBar()
        setupProgressBar()
        setupProgressLabel()
        setupConstraints()
        updateProgress()
    }
    
    private func setupBackgroundBar() {
        backgroundBar.backgroundColor = AppColors.componentsColor
        backgroundBar.layer.cornerRadius = AppCornerRadius.sm
        backgroundBar.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundBar)
    }
    
    private func setupProgressBar() {
        progressBar.layer.cornerRadius = AppCornerRadius.sm
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        backgroundBar.addSubview(progressBar)
        
        // Setup gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [progressColor.cgColor, progressColor.withAlphaComponent(0.8).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.cornerRadius = AppCornerRadius.sm
        
        progressBar.layer.insertSublayer(gradientLayer, at: 0)
        self.progressLayer = gradientLayer
    }
    
    private func setupProgressLabel() {
        progressLabel.font = UIFont.systemFont(ofSize: AppTypography.caption1, weight: AppTypography.medium)
        progressLabel.textColor = AppColors.textSecondary
        progressLabel.textAlignment = .center
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.isHidden = !showPercentage
        addSubview(progressLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Background Bar
            backgroundBar.topAnchor.constraint(equalTo: topAnchor),
            backgroundBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundBar.heightAnchor.constraint(equalToConstant: 8),
            
            // Progress Bar
            progressBar.topAnchor.constraint(equalTo: backgroundBar.topAnchor),
            progressBar.leadingAnchor.constraint(equalTo: backgroundBar.leadingAnchor),
            progressBar.bottomAnchor.constraint(equalTo: backgroundBar.bottomAnchor),
            progressBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: CGFloat(progress)),
            
            // Progress Label
            progressLabel.topAnchor.constraint(equalTo: backgroundBar.bottomAnchor, constant: AppSpacing.xs),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            progressLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Private Methods
    
    private func updateProgress() {
        let progressWidth = backgroundBar.widthAnchor.constraint(equalTo: backgroundBar.widthAnchor, multiplier: CGFloat(progress))
        progressWidth.isActive = true
        
        if showPercentage {
            progressLabel.text = "\(Int(progress * 100))%"
        }
        
        // Animate progress change
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.layoutIfNeeded()
        })
    }
    
    private func updateProgressColor() {
        progressLayer?.colors = [progressColor.cgColor, progressColor.withAlphaComponent(0.8).cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        progressLayer?.frame = progressBar.bounds
    }
    
    // MARK: - Public Methods
    
    func setProgress(_ newProgress: Float, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                self.progress = newProgress
            })
        } else {
            progress = newProgress
        }
    }
    
    func setProgressColor(_ color: UIColor, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.progressColor = color
            })
        } else {
            progressColor = color
        }
    }
}
