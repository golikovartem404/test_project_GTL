//
//  BlackListDetailViewController.swift
//  test_project_GTL
//
//  Created by User on 07.01.2023.
//

import UIKit
import SafariServices

protocol BlackListDelegate: AnyObject {
    var blackListObject: WebsitesList { get set }
    func reloadData()
}

class BlackListDetailViewController: UIViewController {

    let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
    var delegate: BlackListDelegate?

    private lazy var siteAddressTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.placeholder = "Enter site address"
        return textField
    }()

    private lazy var imageslabel: UILabel = {
        let label = UILabel()
        label.text = "Block images"
        label.textColor = .black
        return label
    }()

    private lazy var contentImagesSwitch: UISwitch = {
        let mySwitch = UISwitch()
//        mySwitch.addTarget(self, action: #selector(changeImageBlockerState), for: .valueChanged)
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
//        mySwitch.addTarget(self, action: #selector(changeMediaBlockerState), for: .valueChanged)
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
        button.setTitle("Add site", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(addSiteToList), for: .touchUpInside)
        button.backgroundColor = .black
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(siteAddressTextField)
        imagesStack.addArrangedSubview(imageslabel)
        imagesStack.addArrangedSubview(contentImagesSwitch)
        view.addSubview(imagesStack)
        mediaStack.addArrangedSubview(medialabel)
        mediaStack.addArrangedSubview(contentMediaSwitch)
        view.addSubview(mediaStack)
        view.addSubview(button)
    }

    private func setupLayout() {
        siteAddressTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.3)
            make.width.equalTo(view.snp.width).multipliedBy(0.7)
            make.height.equalTo(40)
        }
        imagesStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.5)
        }

        mediaStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.6)
        }

        button.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.85)
            make.width.equalTo(view.snp.width).multipliedBy(0.3)
            make.height.equalTo(36)
        }
    }

    @objc func addSiteToList() {
        if let text = siteAddressTextField.text {
            activateFilterBlock(fileName: "whiteList", website: text)
        }
    }

    func activateFilterBlock(fileName: String, website: String) {
        var data = [String: [String: Any]]()
        guard let delegate = delegate else { return }
        let imagesSwitchState = contentImagesSwitch.isOn
        let mediaSwitchState = contentMediaSwitch.isOn
        switch (imagesSwitchState, mediaSwitchState) {
        case (true, true):
            data = [
                "action": ["type": "block"],
                "trigger": [
                    "url-filter": ".*\(website)",
                    "resource-type": ["image", "media"]
                ]
            ]
        case (true, false):
            data = [
                "action": ["type": "block"],
                "trigger": [
                    "url-filter": ".*\(website)",
                    "resource-type": ["image"]
                ]
            ]
        case (false, true):
            data = [
                "action": ["type": "block"],
                "trigger": [
                    "url-filter": ".*\(website)",
                    "resource-type": ["media"]
                ]
            ]
        case (false, false):
            data = [
                "action": ["type": "block"],
                "trigger": [
                    "url-filter": ".*\(website)",
                ]
            ]
        case (_, _):
            return
        }
        delegate.blackListObject.append(data)
        UserDefaults(suiteName: appGroupName)?.set(delegate.blackListObject, forKey: "blackListSites")
        writeJSON(
            withObject: delegate.blackListObject,
            andFileName: fileName,
            groupIDentifier: "group.Artem-Golikov.test-project-GTL.batch",
            blockerIDentifier: "Artem-Golikov.test-project-GTL.TestBlocker"
        )
        DispatchQueue.main.async {
            self.delegate?.reloadData()
        }
        dismiss(animated: true)
    }
}
