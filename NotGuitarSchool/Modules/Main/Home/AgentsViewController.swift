//
//  AgentsViewController.swift
//  NotGuitarSchool
//
//  Created by Egorio on 30.09.2025.
//

import UIKit

final class AgentsViewController: UIViewController {

    // MARK: - UI Components
    private let tableView = UITableView()

    // MARK: - Data
    private let agents: [(String, String, String)] = [
        ("Алла Пугачева", "Певица", "Запрещена с 2022 года"),
        ("Максим Галкин", "Пародист", "Запрещен с 2022 года"),
        ("Игорь Николаев", "Композитор", "Запрещен с 2023 года"),
        ("Филипп Киркоров", "Певец", "Запрещен с 2022 года"),
        ("Александр Розенбаум", "Бард", "Запрещен с 2023 года"),
        ("Лариса Долина", "Певица", "Запрещена с 2022 года"),
        ("Валерий Меладзе", "Певец", "Запрещен с 2023 года"),
        ("Ани Лорак", "Певица", "Запрещена с 2022 года"),
        ("Сергей Лазарев", "Певец", "Запрещен с 2023 года"),
        ("Полина Гагарина", "Певица", "Запрещена с 2022 года")
    ]

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = AppColors.backgroundColor
        title = "Реестр музыкантов"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(closeButtonTapped)
        )
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none

        // Register cell (используем статический reuseIdentifier)
        tableView.register(AgentTableViewCell.self, forCellReuseIdentifier: AgentTableViewCell.reuseIdentifier)

        // Авто-высота
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
    }

    // MARK: - Actions
    @objc private func closeButtonTapped() {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension AgentsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Декью по тому же идентификатору, что и при регистрации
        let cell = tableView.dequeueReusableCell(withIdentifier: AgentTableViewCell.reuseIdentifier, for: indexPath) as! AgentTableViewCell
        let agent = agents[indexPath.row]
        cell.configure(name: agent.0, profession: agent.1, status: agent.2)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension AgentsViewController: UITableViewDelegate {
    // можно убрать — если не нужен кастомный фиксированный размер
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - AgentTableViewCell
final class AgentTableViewCell: UITableViewCell {

    static let reuseIdentifier = "AgentCell"

    private let containerView = UIView()
    private let nameLabel = UILabel()
    private let professionLabel = UILabel()
    private let statusLabel = UILabel()
    private let iconLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.backgroundColor = AppColors.componentsColor
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4
        containerView.layer.shadowOpacity = 0.1

        iconLabel.text = "🚫"
        iconLabel.font = UIFont.systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconLabel.translatesAutoresizingMaskIntoConstraints = false

        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.textColor = AppColors.textColor
        nameLabel.numberOfLines = 0
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        professionLabel.font = UIFont.systemFont(ofSize: 14)
        professionLabel.textColor = AppColors.componentsTextColor
        professionLabel.numberOfLines = 0
        professionLabel.translatesAutoresizingMaskIntoConstraints = false

        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = .systemRed
        statusLabel.numberOfLines = 0
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(iconLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(professionLabel)
        containerView.addSubview(statusLabel)

        // Constraints (убрал фиксированную высоту containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            iconLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            iconLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 36),
            iconLabel.heightAnchor.constraint(equalToConstant: 36),

            nameLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),

            professionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            professionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            professionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),

            statusLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            statusLabel.topAnchor.constraint(equalTo: professionLabel.bottomAnchor, constant: 4),
            statusLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])

        // Приоритеты, чтобы иконка не растягивала строку
        iconLabel.setContentHuggingPriority(.required, for: .horizontal)
        iconLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    // <- ЗДЕСЬ именно этот метод должен существовать
    func configure(name: String, profession: String, status: String) {
        nameLabel.text = name
        professionLabel.text = profession
        statusLabel.text = status
    }
}
