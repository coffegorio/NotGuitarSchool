//
//  HomeViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

class HomeViewController: UIViewController {

    private let greetingView = GreetingView()
    private let countdownContainer = AppContainerView(containerColor: AppColors.mainAccentColor)
    private let countdownTitleLabel = AppLabel(text: "До концерта осталось…", style: .headline, textColor: AppColors.textColor)
    private let countdownValueLabel = AppLabel(text: "--д --ч --м", style: .greetings, textColor: AppColors.textColor)
    
    private let tilesGrid = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        title = "Главная"
        
        view.addSubview(greetingView)
        view.addSubview(countdownContainer)
        
        // Countdown content layout
        let countdownStack = UIStackView(arrangedSubviews: [countdownTitleLabel, countdownValueLabel])
        countdownStack.axis = .vertical
        countdownStack.spacing = 8
        countdownStack.translatesAutoresizingMaskIntoConstraints = false
        countdownContainer.addSubview(countdownStack)
        
        // Tiles grid setup (2 columns)
        tilesGrid.axis = .vertical
        tilesGrid.spacing = 12
        tilesGrid.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tilesGrid)
        
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            greetingView.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 24),
            greetingView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
            greetingView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20)
        ])
        
        greetingView.updateGreeting()
        
        NSLayoutConstraint.activate([
            countdownContainer.topAnchor.constraint(equalTo: greetingView.bottomAnchor, constant: 16),
            countdownContainer.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
            countdownContainer.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            countdownStack.topAnchor.constraint(equalTo: countdownContainer.topAnchor, constant: 16),
            countdownStack.leadingAnchor.constraint(equalTo: countdownContainer.leadingAnchor, constant: 16),
            countdownStack.trailingAnchor.constraint(equalTo: countdownContainer.trailingAnchor, constant: -16),
            countdownStack.bottomAnchor.constraint(equalTo: countdownContainer.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tilesGrid.topAnchor.constraint(equalTo: countdownContainer.bottomAnchor, constant: 16),
            tilesGrid.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 20),
            tilesGrid.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -20)
        ])
        
        // Demo tiles
        addTiles([
            ("Текущий урок", "3 из 10"),
            ("Время практики", "45 мин сегодня"),
            ("Прогресс недели", "70%"),
            ("Следующий урок", "Пятница, 18:00")
        ])
        
        // Demo countdown target: +7 дней
        startCountdown(to: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date())
    }

    // MARK: - Tiles
    
    private func addTiles(_ items: [(String, String)]) {
        var rowStack: UIStackView?
        for (index, item) in items.enumerated() {
            if index % 2 == 0 {
                let row = UIStackView()
                row.axis = .horizontal
                row.spacing = 12
                row.distribution = .fillEqually
                row.translatesAutoresizingMaskIntoConstraints = false
                tilesGrid.addArrangedSubview(row)
                rowStack = row
            }
            let tile = InfoTileView()
            tile.configure(title: item.0, value: item.1)
            rowStack?.addArrangedSubview(tile)
        }
    }
    
    // MARK: - Countdown
    
    private var countdownTimer: Timer?
    
    private func startCountdown(to date: Date) {
        countdownTimer?.invalidate()
        updateCountdown(targetDate: date)
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.updateCountdown(targetDate: date)
        }
    }
    
    private func updateCountdown(targetDate: Date) {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute], from: now, to: targetDate)
        let days = max(0, components.day ?? 0)
        let hours = max(0, components.hour ?? 0) % 24
        let minutes = max(0, components.minute ?? 0) % 60
        countdownValueLabel.text = "\(days)д \(hours)ч \(minutes)м"
    }
}
