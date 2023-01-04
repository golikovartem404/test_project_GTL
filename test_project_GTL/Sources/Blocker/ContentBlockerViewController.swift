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

    private lazy var siteTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        return textField
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add site", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.addTarget(self, action: #selector(addSiteToBlackList), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Black list"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
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
        view.addSubview(siteTextField)
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

        siteTextField.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.4)
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
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

    @objc func addSiteToBlackList() {
        guard let siteAddress = siteTextField.text else { return }
        activateFilterBlock(fileName: "whiteList", website: siteAddress)
//        addNewSiteToBlackList(siteName: siteAddress)
    }

    func activateFilterBlock(fileName: String, website: String) {
        let data = [["action": ["type": "block"], "trigger": ["url-filter": "\(website)"]]]
        self.blackListArray.insert(contentsOf: data, at: 0)
        let jsonData = try! JSONSerialization.data(withJSONObject: blackListArray, options: .prettyPrinted)
        if let json = String(data: jsonData, encoding: String.Encoding.utf8) {
            let file = "\(fileName).json"
            if let dir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch") {
                let path = dir.appendingPathComponent(file)
                do {
                    print(json)
                    try json.write(to: path, atomically: false, encoding: String.Encoding.utf8)
                    SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.TestBlocker") { error in
                        guard error == nil else {
                            print(error ?? "Error")
                            return
                        }
                        print("Reloaded - site \(website) was added")
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }

    func addNewSiteToBlackList(siteName: String) {
        let data = ["action": ["type": "block"], "trigger": ["url-filter": "\(siteName)"]]
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let encoded = try? encoder.encode(data) {
            let sharedContainerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.Artem-Golikov.test-project-GTL.batch")
            if let destinationURL = sharedContainerURL?.appendingPathComponent("blackList.json") {
                print(destinationURL)
                do {
                    print(encoded)
                    try encoded.write(to: destinationURL)
                    print("Success added")
                    SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.TestBlocker") { IDerror in
                        if IDerror != nil {
                            print(IDerror?.localizedDescription ?? "ERROR: NOT RELOAD")
                        } else {
                            print("Reloaded")
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
                do {
                    let newData = try Data(contentsOf: destinationURL)
                    let jsonResult = try JSONSerialization.jsonObject(with: newData)
                    if let jsonAsString = jsonResult as? Dictionary<String, Any> {
                        print(jsonAsString)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
        //        let jsonData = try! JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
    }
}
