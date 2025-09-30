//
//  TuningListViewController.swift
//  NotGuitarSchool
//

import UIKit

final class TuningListViewController: UITableViewController {

    var tunings: [GuitarTuning] = []
    var selectedIndex: Int = 0
    var onSelect: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Выбор строя"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeTapped))
    }

    @objc private func closeTapped() {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tunings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tuning = tunings[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = tuning.name
        cell.contentConfiguration = content
        cell.accessoryType = indexPath.row == selectedIndex ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        onSelect?(selectedIndex)
        dismiss(animated: true, completion: nil)
    }
}


