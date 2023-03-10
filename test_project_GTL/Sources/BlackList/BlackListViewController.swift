//
//  BlackListViewController.swift
//  test_project_GTL
//
//  Created by User on 04.01.2023.
//

import UIKit
import SafariServices

class BlackListViewController: UIViewController {

    let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
    var blackListObject: WebsitesList

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

    init() {
        self.blackListObject = UserDefaults(suiteName: "group.Artem-Golikov.test-project-GTL.batch")?.object(forKey: "blackListSites") as! WebsitesList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Black List"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupHierarchy()
        setupLayout()

    }

    private func setupHierarchy() {
        view.addSubview(gradientImage)
        view.addSubview(blackListTable)
        view.addSubview(button)
    }

    private func setupLayout() {
        gradientImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        button.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.7)
            make.height.equalTo(48)
            make.width.equalTo(120)
        }

        blackListTable.snp.makeConstraints { make in
            make.top.equalTo(view.snp.centerY).multipliedBy(0.35)
            make.leading.trailing.bottom.equalTo(view)
        }
    }

    @objc func addSite() {
        let nextVC = BlackListDetailViewController()
        nextVC.delegate = self
        present(nextVC, animated: true)
    }
}

extension BlackListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blackListObject.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.backgroundColor = .clear
        let websiteByIndex = blackListObject[indexPath.row]
        let websiteAddress = websiteByIndex["trigger"]?["url-filter"] as? String
        cell.textLabel?.text = websiteAddress
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

    func removeSite(withIndex index: Int, fromFile fileName: String) {
        guard !blackListObject.isEmpty else { return }
        blackListObject.remove(at: index)
        UserDefaults(suiteName: appGroupName)?.set(blackListObject, forKey: "blackListSites")
        writeJSON(
            withObject: blackListObject,
            andFileName: fileName,
            groupIDentifier: "group.Artem-Golikov.test-project-GTL.batch",
            blockerIDentifier: "Artem-Golikov.test-project-GTL.TestBlocker"
        )
    }
}

extension BlackListViewController: BlackListDelegate {
    func reloadData() {
        DispatchQueue.main.async {
            self.blackListTable.reloadData()
        }
    }
}
