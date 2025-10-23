//
//  ChordsView.swift
//  NotGuitarSchool
//
//  Created by Assistant on 30.09.2025.
//

import UIKit

protocol ChordsViewDelegate: AnyObject {
    func chordsViewDidSelectChord(_ chordsView: ChordsView, chord: Chord)
}

struct Chord {
    let name: String
    let fingering: [Int] // 0 = open string, -1 = muted, 1-4 = finger positions
    let difficulty: ChordDifficulty
    let category: ChordCategory
    
    enum ChordDifficulty: String, CaseIterable {
        case beginner = "Начинающий"
        case intermediate = "Средний"
        case advanced = "Продвинутый"
        
        var color: UIColor {
            switch self {
            case .beginner: return AppColors.secondaryGreen
            case .intermediate: return AppColors.accentOrange
            case .advanced: return AppColors.warningRed
            }
        }
    }
    
    enum ChordCategory: String, CaseIterable {
        case major = "Мажорные"
        case minor = "Минорные"
        case seventh = "Септаккорды"
        case suspended = "Сас-аккорды"
    }
}

final class ChordsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: ChordsViewDelegate?
    
    private var chords: [Chord] = []
    private var filteredChords: [Chord] = []
    
    // MARK: - UI Components
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    
    private let titleLabel = AppLabel(
        text: "Аккорды",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let searchTextField = AppTextField(
        placeholder: "Поиск аккордов...",
        isFilled: true,
        color: AppColors.primaryBlue
    )
    
    private let categorySegmentedControl = UISegmentedControl(items: ["Все", "Мажорные", "Минорные", "Септаккорды"])
    private let difficultySegmentedControl = UISegmentedControl(items: ["Все", "Начинающий", "Средний", "Продвинутый"])
    
    private let chordsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = AppSpacing.sm
        layout.minimumLineSpacing = AppSpacing.md
        layout.sectionInset = UIEdgeInsets(top: AppSpacing.md, left: AppSpacing.md, bottom: AppSpacing.md, right: AppSpacing.md)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
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
        backgroundColor = .clear
        setupUI()
        setupConstraints()
        setupActions()
        loadChords()
    }
    
    private func setupUI() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Title
        contentView.addArrangedSubview(titleLabel)
        
        // Search
        contentView.addArrangedSubview(searchTextField)
        
        // Category filter
        categorySegmentedControl.selectedSegmentIndex = 0
        categorySegmentedControl.backgroundColor = AppColors.componentsColor
        categorySegmentedControl.selectedSegmentTintColor = AppColors.primaryBlue
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        categorySegmentedControl.setTitleTextAttributes([.foregroundColor: AppColors.componentsTextColor], for: .normal)
        contentView.addArrangedSubview(categorySegmentedControl)
        
        // Difficulty filter
        difficultySegmentedControl.selectedSegmentIndex = 0
        difficultySegmentedControl.backgroundColor = AppColors.componentsColor
        difficultySegmentedControl.selectedSegmentTintColor = AppColors.primaryBlue
        difficultySegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        difficultySegmentedControl.setTitleTextAttributes([.foregroundColor: AppColors.componentsTextColor], for: .normal)
        contentView.addArrangedSubview(difficultySegmentedControl)
        
        // Collection view
        chordsCollectionView.delegate = self
        chordsCollectionView.dataSource = self
        chordsCollectionView.register(ChordCell.self, forCellWithReuseIdentifier: "ChordCell")
        contentView.addArrangedSubview(chordsCollectionView)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        categorySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        difficultySegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        chordsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.axis = .vertical
        contentView.spacing = AppSpacing.md
        contentView.alignment = .fill
        
        NSLayoutConstraint.activate([
            // Scroll view
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Content view
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: AppSpacing.md),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: AppSpacing.md),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -AppSpacing.md),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -AppSpacing.md),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -AppSpacing.xl),
            
            // Search field
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Segmented controls
            categorySegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            difficultySegmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            // Collection view
            chordsCollectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    private func setupActions() {
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        categorySegmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
        difficultySegmentedControl.addTarget(self, action: #selector(difficultyChanged), for: .valueChanged)
    }
    
    // MARK: - Actions
    
    @objc private func searchTextChanged() {
        filterChords()
    }
    
    @objc private func categoryChanged() {
        filterChords()
    }
    
    @objc private func difficultyChanged() {
        filterChords()
    }
    
    // MARK: - Private Methods
    
    private func loadChords() {
        chords = [
            // Major chords
            Chord(name: "C", fingering: [0, 1, 0, 2, 1, 0], difficulty: .beginner, category: .major),
            Chord(name: "D", fingering: [-1, -1, 0, 2, 3, 2], difficulty: .beginner, category: .major),
            Chord(name: "E", fingering: [0, 2, 2, 1, 0, 0], difficulty: .beginner, category: .major),
            Chord(name: "F", fingering: [1, 3, 3, 2, 1, 1], difficulty: .intermediate, category: .major),
            Chord(name: "G", fingering: [3, 2, 0, 0, 3, 3], difficulty: .beginner, category: .major),
            Chord(name: "A", fingering: [0, 0, 2, 2, 2, 0], difficulty: .beginner, category: .major),
            Chord(name: "B", fingering: [2, 4, 4, 3, 2, 2], difficulty: .intermediate, category: .major),
            
            // Minor chords
            Chord(name: "Am", fingering: [0, 1, 2, 2, 1, 0], difficulty: .beginner, category: .minor),
            Chord(name: "Dm", fingering: [-1, -1, 0, 2, 3, 1], difficulty: .beginner, category: .minor),
            Chord(name: "Em", fingering: [0, 2, 2, 0, 0, 0], difficulty: .beginner, category: .minor),
            Chord(name: "Fm", fingering: [1, 3, 3, 1, 1, 1], difficulty: .intermediate, category: .minor),
            Chord(name: "Gm", fingering: [3, 5, 5, 3, 3, 3], difficulty: .intermediate, category: .minor),
            Chord(name: "Bm", fingering: [2, 4, 4, 2, 2, 2], difficulty: .intermediate, category: .minor),
            
            // Seventh chords
            Chord(name: "C7", fingering: [0, 1, 0, 2, 1, 3], difficulty: .intermediate, category: .seventh),
            Chord(name: "D7", fingering: [-1, -1, 0, 2, 1, 2], difficulty: .intermediate, category: .seventh),
            Chord(name: "E7", fingering: [0, 2, 0, 1, 3, 0], difficulty: .intermediate, category: .seventh),
            Chord(name: "G7", fingering: [3, 2, 0, 0, 0, 1], difficulty: .intermediate, category: .seventh),
            Chord(name: "A7", fingering: [0, 0, 2, 0, 2, 0], difficulty: .intermediate, category: .seventh),
            Chord(name: "B7", fingering: [2, 4, 2, 3, 2, 2], difficulty: .advanced, category: .seventh),
            
            // Suspended chords
            Chord(name: "Csus2", fingering: [0, 3, 0, 2, 1, 0], difficulty: .intermediate, category: .suspended),
            Chord(name: "Csus4", fingering: [0, 1, 3, 2, 1, 0], difficulty: .intermediate, category: .suspended),
            Chord(name: "Dsus2", fingering: [-1, -1, 0, 2, 3, 0], difficulty: .intermediate, category: .suspended),
            Chord(name: "Dsus4", fingering: [-1, -1, 0, 2, 3, 3], difficulty: .intermediate, category: .suspended),
            Chord(name: "Gsus2", fingering: [3, 0, 0, 0, 3, 3], difficulty: .intermediate, category: .suspended),
            Chord(name: "Gsus4", fingering: [3, 2, 0, 0, 1, 3], difficulty: .intermediate, category: .suspended)
        ]
        
        filteredChords = chords
        chordsCollectionView.reloadData()
    }
    
    private func filterChords() {
        let searchText = searchTextField.text?.lowercased() ?? ""
        
        filteredChords = chords.filter { chord in
            let matchesSearch = searchText.isEmpty || chord.name.lowercased().contains(searchText)
            
            let categoryIndex = categorySegmentedControl.selectedSegmentIndex
            let matchesCategory = categoryIndex == 0 || {
                switch categoryIndex {
                case 1: return chord.category == .major
                case 2: return chord.category == .minor
                case 3: return chord.category == .seventh
                default: return true
                }
            }()
            
            let difficultyIndex = difficultySegmentedControl.selectedSegmentIndex
            let matchesDifficulty = difficultyIndex == 0 || {
                switch difficultyIndex {
                case 1: return chord.difficulty == .beginner
                case 2: return chord.difficulty == .intermediate
                case 3: return chord.difficulty == .advanced
                default: return true
                }
            }()
            
            return matchesSearch && matchesCategory && matchesDifficulty
        }
        
        chordsCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource

extension ChordsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredChords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChordCell", for: indexPath) as! ChordCell
        cell.configure(with: filteredChords[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ChordsView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let chord = filteredChords[indexPath.item]
        delegate?.chordsViewDidSelectChord(self, chord: chord)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ChordsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - AppSpacing.md * 3) / 2
        return CGSize(width: width, height: 160)
    }
}

// MARK: - ChordCell

final class ChordCell: UICollectionViewCell {
    
    private let containerView = AppCardView(
        backgroundColor: AppColors.surfacePrimary,
        cornerRadius: AppCornerRadius.md,
        shadow: AppShadows.small
    )
    
    private let chordNameLabel = AppLabel(
        text: "",
        style: .headline,
        textColor: AppColors.textPrimary
    )
    
    private let difficultyLabel = AppLabel(
        text: "",
        style: .caption,
        textColor: AppColors.textSecondary
    )
    
    private let categoryLabel = AppLabel(
        text: "",
        style: .caption,
        textColor: AppColors.textSecondary
    )
    
    private let fingeringView = ChordFingeringView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.addSubview(containerView)
        containerView.addSubview(chordNameLabel)
        containerView.addSubview(difficultyLabel)
        containerView.addSubview(categoryLabel)
        containerView.addSubview(fingeringView)
        
        chordNameLabel.textAlignment = .center
        difficultyLabel.textAlignment = .center
        categoryLabel.textAlignment = .center
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        chordNameLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        fingeringView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            chordNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: AppSpacing.sm),
            chordNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppSpacing.sm),
            chordNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppSpacing.sm),
            
            difficultyLabel.topAnchor.constraint(equalTo: chordNameLabel.bottomAnchor, constant: AppSpacing.xs),
            difficultyLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppSpacing.sm),
            difficultyLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppSpacing.sm),
            
            categoryLabel.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: AppSpacing.xs),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppSpacing.sm),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppSpacing.sm),
            
            fingeringView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: AppSpacing.sm),
            fingeringView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: AppSpacing.sm),
            fingeringView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -AppSpacing.sm),
            fingeringView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -AppSpacing.sm),
            fingeringView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    func configure(with chord: Chord) {
        chordNameLabel.text = chord.name
        difficultyLabel.text = chord.difficulty.rawValue
        categoryLabel.text = chord.category.rawValue
        
        // Update difficulty label color
        difficultyLabel.textColor = chord.difficulty.color
        
        // Configure fingering view
        fingeringView.configure(with: chord.fingering)
    }
}

// MARK: - ChordFingeringView

final class ChordFingeringView: UIView {
    
    private let stringsStackView = UIStackView()
    private let fretsStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stringsStackView.axis = .horizontal
        stringsStackView.distribution = .fillEqually
        stringsStackView.spacing = 2
        stringsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        fretsStackView.axis = .horizontal
        fretsStackView.distribution = .fillEqually
        fretsStackView.spacing = 2
        fretsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stringsStackView)
        addSubview(fretsStackView)
        
        NSLayoutConstraint.activate([
            stringsStackView.topAnchor.constraint(equalTo: topAnchor),
            stringsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stringsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stringsStackView.heightAnchor.constraint(equalToConstant: 20),
            
            fretsStackView.topAnchor.constraint(equalTo: stringsStackView.bottomAnchor, constant: 2),
            fretsStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            fretsStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            fretsStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with fingering: [Int]) {
        // Clear existing views
        stringsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        fretsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Create string indicators (E, A, D, G, B, E)
        let stringNames = ["E", "A", "D", "G", "B", "E"]
        for (index, name) in stringNames.enumerated() {
            let label = UILabel()
            label.text = name
            label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
            label.textColor = AppColors.textSecondary
            label.textAlignment = .center
            stringsStackView.addArrangedSubview(label)
        }
        
        // Create fret indicators
        for (index, fret) in fingering.enumerated() {
            let label = UILabel()
            if fret == -1 {
                label.text = "✕"
                label.textColor = AppColors.warningRed
            } else if fret == 0 {
                label.text = "○"
                label.textColor = AppColors.textSecondary
            } else {
                label.text = "\(fret)"
                label.textColor = AppColors.primaryBlue
            }
            label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
            label.textAlignment = .center
            fretsStackView.addArrangedSubview(label)
        }
    }
}
