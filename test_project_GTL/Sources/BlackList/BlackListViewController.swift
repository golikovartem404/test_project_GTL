//
//  BlackListViewController.swift
//  test_project_GTL
//
//  Created by User on 04.01.2023.
//

import UIKit
import SafariServices

class BlackListViewController: UIViewController {

    var blackListArray = [[String: [String: String]]]()

    private lazy var gradientImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "gradient"))
        image.contentMode = .scaleAspectFill
        return image
    }()

    private lazy var blackListTable: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = .clear
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.dataSource = self
        table.delegate = self
        return table
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add site", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 24
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(addSite), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Black List"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(gradientImage)
        view.addSubview(button)
        view.addSubview(blackListTable)
    }

    private func setupLayout() {
        gradientImage.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view)
        }

        button.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.18)
            make.height.equalTo(48)
            make.width.equalTo(120)
        }

        blackListTable.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).multipliedBy(0.35)
            make.leading.trailing.bottom.equalTo(view)
        }
    }

    @objc func addSite() {
        showAddSiteAlert()
    }
}

extension BlackListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blackListArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        let address = blackListArray[indexPath.row]
        let value = address["trigger"]?["url-filter"]
        cell.textLabel?.text = value
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont(name: "avenir", size: 18)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            self.removeSite(withIndex: indexPath.row, fromFile: "whiteList")
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension BlackListViewController {

    func showAddSiteAlert() {
        let alert = UIAlertController(title: "New site", message: "Please enter a new site address", preferredStyle: .alert)
        alert.addTextField()
        let actionAdd = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = alert.textFields?.first?.text {
                self.activateFilterBlock(fileName: "whiteList", website: text)
            }
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionAdd)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }

    func activateFilterBlock(fileName: String, website: String) {
        let data = [["action": ["type": "block"], "trigger": ["url-filter": "\(website)"]]]
        self.blackListArray.append(contentsOf: data)
        DispatchQueue.main.async {
            self.blackListTable.reloadData()
        }
//        let jsonData = try! JSONSerialization.data(
//            withJSONObject: blackListArray,
//            options: .prettyPrinted
//        )
//        if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
//            let file = "\(fileName).json"
//            if let dir = FileManager.default.containerURL(
//                forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch"
//            ) {
//                let path = dir.appendingPathComponent(file)
//                do {
//                    print(json)
//                    try json.write(
//                        to: path,
//                        atomically: false,
//                        encoding: String.Encoding.utf8
//                    )
//                    SFContentBlockerManager.reloadContentBlocker(
//                        withIdentifier: "Artem-Golikov.test-project-GTL.TestBlocker"
//                    ) { error in
//                        guard error == nil else {
//                            print(error ?? "Error")
//                            return
//                        }
//                        print("Reloaded - site \(website) was added")
//                    }
//                } catch {
//                    print(error.localizedDescription)
//                }
//            }
//        }
        writeJSON(withObject: blackListArray, andFileName: fileName)
    }

    func removeSite(withIndex index: Int, fromFile fileName: String) {
        if !blackListArray.isEmpty {
            blackListArray.remove(at: index)
//            let jsonData = try! JSONSerialization.data(
//                withJSONObject: blackListArray,
//                options: .prettyPrinted
//            )
//            if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
//                let file = "\(fileName).json"
//                if let dir = FileManager.default.containerURL(
//                    forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch"
//                ) {
//                    let path = dir.appendingPathComponent(file)
//                    do {
//                        print(json)
//                        try json.write(
//                            to: path,
//                            atomically: false,
//                            encoding: String.Encoding.utf8
//                        )
//                        SFContentBlockerManager.reloadContentBlocker(
//                            withIdentifier: "Artem-Golikov.test-project-GTL.TestBlocker"
//                        ) { error in
//                            guard error == nil else {
//                                print(error ?? "Error")
//                                return
//                            }
//                            print("Reloaded - site was removed")
//                        }
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                }
//            }
            self.writeJSON(withObject: blackListArray, andFileName: fileName)
        }
    }

    func writeJSON(withObject object: Any, andFileName fileName: String) {
        let jsonData = try! JSONSerialization.data(
            withJSONObject: object,
            options: .prettyPrinted
        )
        if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            let file = "\(fileName).json"
            if let dir = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch"
            ) {
                let path = dir.appendingPathComponent(file)
                do {
                    print(json)
                    try json.write(
                        to: path,
                        atomically: false,
                        encoding: String.Encoding.utf8
                    )
                    SFContentBlockerManager.reloadContentBlocker(
                        withIdentifier: "Artem-Golikov.test-project-GTL.TestBlocker"
                    ) { error in
                        guard error == nil else {
                            print(error ?? "Error")
                            return
                        }
                        print("Reloaded successfully")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
