//
//  MetronomeView.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit
import AVFoundation

protocol MetronomeViewDelegate: AnyObject {
    func metronomeViewDidChangeTempo(_ metronomeView: MetronomeView, tempo: Int)
    func metronomeViewDidChangeTimeSignature(_ metronomeView: MetronomeView, timeSignature: TimeSignature)
    func metronomeViewDidTogglePlayback(_ metronomeView: MetronomeView, isPlaying: Bool)
}

struct TimeSignature {
    let beats: Int
    let noteValue: Int
    
    var displayString: String {
        return "\(beats)/\(noteValue)"
    }
}

final class MetronomeView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: MetronomeViewDelegate?
    
    private var tempo: Int = 120 {
        didSet {
            tempoLabel.text = "\(tempo) BPM"
            delegate?.metronomeViewDidChangeTempo(self, tempo: tempo)
        }
    }
    
    private var timeSignature: TimeSignature = TimeSignature(beats: 4, noteValue: 4) {
        didSet {
            timeSignatureLabel.text = timeSignature.displayString
            delegate?.metronomeViewDidChangeTimeSignature(self, timeSignature: timeSignature)
        }
    }
    
    private var isPlaying: Bool = false {
        didSet {
            playButton.setTitle(isPlaying ? "⏸️" : "▶️", for: .normal)
            playButton.backgroundColor = isPlaying ? AppColors.warningRed : AppColors.secondaryGreen
            delegate?.metronomeViewDidTogglePlayback(self, isPlaying: isPlaying)
        }
    }
    
    // MARK: - UI Components
    
    private let containerCard = AppCardView(
        backgroundColor: AppColors.surfacePrimary,
        cornerRadius: AppCornerRadius.lg,
        shadow: AppShadows.medium
    )
    
    private let titleLabel = AppLabel(
        text: "Метроном",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let tempoLabel = AppLabel(
        text: "120 BPM",
        style: .greetings,
        textColor: AppColors.primaryBlue
    )
    
    private let timeSignatureLabel = AppLabel(
        text: "4/4",
        style: .headline,
        textColor: AppColors.textSecondary
    )
    
    private let tempoSlider = UISlider()
    private let timeSignatureSegmentedControl = UISegmentedControl(items: ["4/4", "3/4", "2/4"])
    
    private let playButton = AppGradientButton(
        title: "▶️",
        gradient: AppGradients.success,
        cornerRadius: AppCornerRadius.round
    )
    
    private let tempoStackView = UIStackView()
    private let timeSignatureStackView = UIStackView()
    private let controlsStackView = UIStackView()
    
    // MARK: - Initialization
    
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
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        addSubview(containerCard)
        
        // Tempo slider setup
        tempoSlider.minimumValue = 60
        tempoSlider.maximumValue = 200
        tempoSlider.value = Float(tempo)
        tempoSlider.tintColor = AppColors.primaryBlue
        tempoSlider.translatesAutoresizingMaskIntoConstraints = false
        
        // Time signature segmented control setup
        timeSignatureSegmentedControl.selectedSegmentIndex = 0
        timeSignatureSegmentedControl.backgroundColor = AppColors.componentsColor
        timeSignatureSegmentedControl.selectedSegmentTintColor = AppColors.primaryBlue
        timeSignatureSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        timeSignatureSegmentedControl.setTitleTextAttributes([.foregroundColor: AppColors.componentsTextColor], for: .normal)
        timeSignatureSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        // Play button setup
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Stack views setup
        setupStackViews()
    }
    
    private func setupStackViews() {
        // Tempo stack
        tempoStackView.axis = .vertical
        tempoStackView.spacing = AppSpacing.sm
        tempoStackView.alignment = .center
        tempoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let tempoTitleLabel = AppLabel(
            text: "Темп",
            style: .body,
            textColor: AppColors.textSecondary
        )
        tempoTitleLabel.textAlignment = .center
        
        tempoStackView.addArrangedSubview(tempoTitleLabel)
        tempoStackView.addArrangedSubview(tempoLabel)
        tempoStackView.addArrangedSubview(tempoSlider)
        
        // Time signature stack
        timeSignatureStackView.axis = .vertical
        timeSignatureStackView.spacing = AppSpacing.sm
        timeSignatureStackView.alignment = .center
        timeSignatureStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let timeSignatureTitleLabel = AppLabel(
            text: "Размер",
            style: .body,
            textColor: AppColors.textSecondary
        )
        timeSignatureTitleLabel.textAlignment = .center
        
        timeSignatureStackView.addArrangedSubview(timeSignatureTitleLabel)
        timeSignatureStackView.addArrangedSubview(timeSignatureLabel)
        timeSignatureStackView.addArrangedSubview(timeSignatureSegmentedControl)
        
        // Controls stack
        controlsStackView.axis = .horizontal
        controlsStackView.spacing = AppSpacing.lg
        controlsStackView.distribution = .fillEqually
        controlsStackView.alignment = .center
        controlsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        controlsStackView.addArrangedSubview(tempoStackView)
        controlsStackView.addArrangedSubview(timeSignatureStackView)
        
        // Add all components to container
        containerCard.addSubview(titleLabel)
        containerCard.addSubview(controlsStackView)
        containerCard.addSubview(playButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Container card
            containerCard.topAnchor.constraint(equalTo: topAnchor),
            containerCard.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerCard.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerCard.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: containerCard.topAnchor, constant: AppSpacing.lg),
            titleLabel.centerXAnchor.constraint(equalTo: containerCard.centerXAnchor),
            
            // Controls stack
            controlsStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: AppSpacing.lg),
            controlsStackView.leadingAnchor.constraint(equalTo: containerCard.leadingAnchor, constant: AppSpacing.lg),
            controlsStackView.trailingAnchor.constraint(equalTo: containerCard.trailingAnchor, constant: -AppSpacing.lg),
            
            // Play button
            playButton.topAnchor.constraint(equalTo: controlsStackView.bottomAnchor, constant: AppSpacing.lg),
            playButton.centerXAnchor.constraint(equalTo: containerCard.centerXAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 80),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.bottomAnchor.constraint(equalTo: containerCard.bottomAnchor, constant: -AppSpacing.lg),
            
            // Tempo slider
            tempoSlider.widthAnchor.constraint(equalToConstant: 120),
            
            // Time signature segmented control
            timeSignatureSegmentedControl.widthAnchor.constraint(equalToConstant: 120),
            timeSignatureSegmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    private func setupActions() {
        tempoSlider.addTarget(self, action: #selector(tempoSliderChanged), for: .valueChanged)
        timeSignatureSegmentedControl.addTarget(self, action: #selector(timeSignatureChanged), for: .valueChanged)
        playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func tempoSliderChanged() {
        tempo = Int(tempoSlider.value)
    }
    
    @objc private func timeSignatureChanged() {
        let signatures = [
            TimeSignature(beats: 4, noteValue: 4),
            TimeSignature(beats: 3, noteValue: 4),
            TimeSignature(beats: 2, noteValue: 4)
        ]
        
        let selectedIndex = timeSignatureSegmentedControl.selectedSegmentIndex
        if selectedIndex < signatures.count {
            timeSignature = signatures[selectedIndex]
        }
    }
    
    @objc private func playButtonTapped() {
        isPlaying.toggle()
        
        // Add haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
    }
    
    // MARK: - Public Methods
    
    func setTempo(_ newTempo: Int) {
        tempo = max(60, min(200, newTempo))
        tempoSlider.value = Float(tempo)
    }
    
    func setTimeSignature(_ newTimeSignature: TimeSignature) {
        timeSignature = newTimeSignature
        
        // Update segmented control
        let signatures = [
            TimeSignature(beats: 4, noteValue: 4),
            TimeSignature(beats: 3, noteValue: 4),
            TimeSignature(beats: 2, noteValue: 4)
        ]
        
        if let index = signatures.firstIndex(where: { $0.beats == newTimeSignature.beats && $0.noteValue == newTimeSignature.noteValue }) {
            timeSignatureSegmentedControl.selectedSegmentIndex = index
        }
    }
    
    func setPlaying(_ playing: Bool) {
        isPlaying = playing
    }
}
