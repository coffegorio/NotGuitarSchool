//
//  TunaViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit
import AVFoundation

class TunaViewController: UIViewController, TunaViewModelDelegate {

    // UI
    private let noteLabel = UILabel()
    private let freqLabel = UILabel()
    private let centsLabel = UILabel()
    private let adviceLabel = UILabel()
    private let tuningNameLabel = UILabel()
    private let selectTuningButton = AppButton(title: "Выбрать строй")
    private let needleView = TunerNeedleView()
    private let haptic = UINotificationFeedbackGenerator()
    
    // Metronome
    private let metronomeView = MetronomeView()
    private let metronomeToggleButton = AppButton(title: "Метроном", isFilled: false)
    private var isMetronomeVisible = false

    private let viewModel = TunaViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.delegate = self
        viewModel.requestPermissionAndStart()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        title = "Тюнер"

        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.text = "---"
        noteLabel.textAlignment = .center
        noteLabel.font = UIFont.monospacedSystemFont(ofSize: 60, weight: .bold)
        noteLabel.textColor = .label

        freqLabel.translatesAutoresizingMaskIntoConstraints = false
        freqLabel.text = "-- Hz"
        freqLabel.textAlignment = .center
        freqLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 28, weight: .medium)
        freqLabel.textColor = .secondaryLabel

        centsLabel.translatesAutoresizingMaskIntoConstraints = false
        centsLabel.text = "±0 c"
        centsLabel.textAlignment = .center
        centsLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: .regular)
        centsLabel.textColor = .tertiaryLabel

        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.numberOfLines = 2
        adviceLabel.textAlignment = .center
        adviceLabel.font = UIFont.systemFont(ofSize: 28, weight: .semibold)
        adviceLabel.textColor = .secondaryLabel

        tuningNameLabel.translatesAutoresizingMaskIntoConstraints = false
        tuningNameLabel.text = ""
        tuningNameLabel.textAlignment = .center
        tuningNameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        tuningNameLabel.textColor = .secondaryLabel

        needleView.translatesAutoresizingMaskIntoConstraints = false
        needleView.rangeHz = 10

        selectTuningButton.translatesAutoresizingMaskIntoConstraints = false
        metronomeToggleButton.translatesAutoresizingMaskIntoConstraints = false
        metronomeView.translatesAutoresizingMaskIntoConstraints = false
        
        [noteLabel, freqLabel, centsLabel, needleView, adviceLabel, tuningNameLabel, selectTuningButton, metronomeToggleButton, metronomeView].forEach { view.addSubview($0) }

        selectTuningButton.addTarget(self, action: #selector(selectTuningTapped), for: .touchUpInside)
        metronomeToggleButton.addTarget(self, action: #selector(metronomeToggleTapped), for: .touchUpInside)
        
        metronomeView.delegate = self
        metronomeView.isHidden = true

        NSLayoutConstraint.activate([
            noteLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 48),
            noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            freqLabel.topAnchor.constraint(equalTo: noteLabel.bottomAnchor, constant: 6),
            freqLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            centsLabel.topAnchor.constraint(equalTo: freqLabel.bottomAnchor, constant: 2),
            centsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            needleView.topAnchor.constraint(equalTo: centsLabel.bottomAnchor, constant: 10),
            needleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            needleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            needleView.heightAnchor.constraint(equalToConstant: 180),

            adviceLabel.topAnchor.constraint(equalTo: needleView.bottomAnchor, constant: 20),
            adviceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            adviceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            adviceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            tuningNameLabel.topAnchor.constraint(equalTo: adviceLabel.bottomAnchor, constant: 24),
            tuningNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            selectTuningButton.topAnchor.constraint(equalTo: tuningNameLabel.bottomAnchor, constant: 8),
            selectTuningButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectTuningButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            selectTuningButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            selectTuningButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Metronome toggle button
            metronomeToggleButton.topAnchor.constraint(equalTo: selectTuningButton.bottomAnchor, constant: 16),
            metronomeToggleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            metronomeToggleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            metronomeToggleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            metronomeToggleButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Metronome view
            metronomeView.topAnchor.constraint(equalTo: metronomeToggleButton.bottomAnchor, constant: 16),
            metronomeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            metronomeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            metronomeView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        // Initialize selected tuning title
        tuningNameLabel.text = viewModel.tunings[viewModel.selectedIndex].name
    }

    @objc private func selectTuningTapped() {
        let list = TuningListViewController(style: .insetGrouped)
        list.tunings = viewModel.tunings
        list.selectedIndex = viewModel.selectedIndex
        list.onSelect = { [weak self] idx in self?.viewModel.selectTuning(index: idx) }
        let nav = UINavigationController(rootViewController: list)
        nav.modalPresentationStyle = .formSheet
        present(nav, animated: true)
    }
    
    @objc private func metronomeToggleTapped() {
        isMetronomeVisible.toggle()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.metronomeView.isHidden = !self.isMetronomeVisible
            self.metronomeView.alpha = self.isMetronomeVisible ? 1.0 : 0.0
            self.metronomeToggleButton.setTitle(self.isMetronomeVisible ? "Скрыть метроном" : "Показать метроном", for: .normal)
        })
    }

    // MARK: - TunaViewModelDelegate
    func tunaViewModelDidUpdate(_ viewModel: TunaViewModel, frequency: Float?, noteName: String?, cents: Double?, deviationHz: Float?) {
        if let f = frequency {
            freqLabel.text = String(format: "%.2f Hz", f)
        } else {
            freqLabel.text = "-- Hz"
        }
        if let n = noteName { noteLabel.text = n } else { noteLabel.text = "---" }
        if let c = cents { centsLabel.text = String(format: "%+0.0f c", c) } else { centsLabel.text = "±0 c" }
        if let d = deviationHz {
            needleView.deviationHz = CGFloat(d)
            let absDiff = abs(d)
            if absDiff < 1 {
                adviceLabel.text = "Точно настроено! 🎸"
                adviceLabel.textColor = .systemGreen
            } else if d > 0 {
                adviceLabel.text = "Ослабьте струну"
                adviceLabel.textColor = absDiff < 2.5 ? .systemOrange : .systemRed
            } else {
                adviceLabel.text = "Подтяните струну"
                adviceLabel.textColor = absDiff < 2.5 ? .systemOrange : .systemRed
            }
        } else {
            needleView.deviationHz = 0
            adviceLabel.text = ""
            adviceLabel.textColor = AppColors.componentsTextColor
        }
    }

    func tunaViewModelDidChangeTuning(_ viewModel: TunaViewModel, tuningName: String) {
        tuningNameLabel.text = tuningName
        noteLabel.text = "---"
        freqLabel.text = "-- Hz"
        centsLabel.text = "±0 c"
        adviceLabel.text = ""
    }

    func tunaViewModelInTuneFeedback() {
        haptic.notificationOccurred(.success)
    }

    func tunaViewModelMicPermissionDenied() {
        noteLabel.text = "Нет доступа к микрофону"
        adviceLabel.text = ""
    }

    func tunaViewModelAudioError(_ message: String) {
        noteLabel.text = message
    }
}

// MARK: - MetronomeViewDelegate

extension TunaViewController: MetronomeViewDelegate {
    func metronomeViewDidChangeTempo(_ metronomeView: MetronomeView, tempo: Int) {
        // Handle tempo change
        print("Tempo changed to: \(tempo)")
    }
    
    func metronomeViewDidChangeTimeSignature(_ metronomeView: MetronomeView, timeSignature: TimeSignature) {
        // Handle time signature change
        print("Time signature changed to: \(timeSignature.displayString)")
    }
    
    func metronomeViewDidTogglePlayback(_ metronomeView: MetronomeView, isPlaying: Bool) {
        // Handle metronome playback toggle
        print("Metronome isPlaying: \(isPlaying)")
    }
}

