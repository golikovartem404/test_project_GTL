//
//  ContentBlockerViewController.swift
//  test_project_GTL
//
//  Created by User on 02.01.2023.
//

import UIKit
import SafariServices

class ContentBlockerViewController: UIViewController {

    var blackListArray = [[String: [String: String]]]()

    private lazy var imageslabel: UILabel = {
        let label = UILabel()
        label.text = "Block images"
        label.textColor = .black
        return label
    }()

    private lazy var contentImagesSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(changeImageBlockerState), for: .valueChanged)
        return mySwitch
    }()

    private lazy var medialabel: UILabel = {
        let label = UILabel()
        label.text = "Block media"
        label.textColor = .black
        return label
    }()

    private lazy var contentMediaSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(changeMediaBlockerState), for: .valueChanged)
        return mySwitch
    }()

    private lazy var imagesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var mediaStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go next VC", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(goToNextVC), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Black list"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
        let defaults = UserDefaults(suiteName: appGroupName)
        defaults?.set(WebsitesList(), forKey: "blackListSites")
        defaults?.set(WebsitesList(), forKey: "whiteListSites")
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        imagesStack.addArrangedSubview(imageslabel)
        imagesStack.addArrangedSubview(contentImagesSwitch)
        view.addSubview(imagesStack)
        mediaStack.addArrangedSubview(medialabel)
        mediaStack.addArrangedSubview(contentMediaSwitch)
        view.addSubview(mediaStack)
        view.addSubview(button)
    }

    private func setupLayout() {
        imagesStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.8)
        }

        mediaStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.2)
        }

        button.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.6)
        }
    }

    @objc func changeImageBlockerState() {
        let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
        let defaults = UserDefaults(suiteName: appGroupName)
        if contentImagesSwitch.isOn {
            print("Set blockerListNew")
            defaults?.set(true, forKey: "isImageBlocked")
            defaults?.synchronize()
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.GamblingBlocker")
        } else {
            print("Set blockerList")
            defaults?.set(false, forKey: "isImageBlocked")
            defaults?.synchronize()
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.GamblingBlocker")
        }
    }

    @objc func changeMediaBlockerState() {
        let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
        let defaults = UserDefaults(suiteName: appGroupName)
        if contentMediaSwitch.isOn {
            print("Set blockerListNew")
            defaults?.set(true, forKey: "isMediaBlocked")
            defaults?.synchronize()
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.GamblingBlocker")
        } else {
            print("Set blockerList")
            defaults?.set(false, forKey: "isMediaBlocked")
            defaults?.synchronize()
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.GamblingBlocker")
        }
    }

    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }


    func transformStrings() {
        guard let jsonFileMain = Bundle.main.url(forResource: "blockerListAdult", withExtension: "json") else {
            print("NO FILE")
            return
        }
        for address in Constants.data2 {
            let data = [["action": ["type": "block"], "trigger": ["url-filter": "\(address)"]]]
            blackListArray.append(contentsOf: data)
            let jsonData = try! JSONSerialization.data(
                withJSONObject: blackListArray,
                options: .prettyPrinted
            )
            if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
                do {
                    try json.write(
                        to: jsonFileMain,
                        atomically: false,
                        encoding: String.Encoding.utf8
                    )
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        do {
            let dataFile = try Data(contentsOf: jsonFileMain)
            if let jsonString = String(data: dataFile, encoding: .utf8) {
                print(jsonString)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }

    @objc func goToNextVC() {
        self.navigationController?.pushViewController(BlackListViewController(), animated: true)
    }
}
