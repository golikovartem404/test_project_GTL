//
//  AdBlockViewController.swift
//  test_project_GTL
//
//  Created by User on 08.01.2023.
//

import UIKit
import SafariServices

class AdBlockViewController: UIViewController {

    private lazy var adBlockSwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.addTarget(self, action: #selector(blockADS), for: .valueChanged)
        return mySwitch
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
    }

    private func setupHierarchy() {
        view.addSubview(adBlockSwitch)
    }

    private func setupLayout() {
        adBlockSwitch.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }

    @objc func blockADS() {
        let appGroupName = "group.Artem-Golikov.test-project-GTL.batch"
        let defaults = UserDefaults(suiteName: appGroupName)
        if adBlockSwitch.isOn {
            print("AD BLOCKED")
            defaults?.set(true, forKey: "isADBlocked")
            defaults?.synchronize()
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.SocialNetwork")
        } else {
            print("AD UNBLOCKED")
            defaults?.set(false, forKey: "isADBlocked")
            defaults?.synchronize()
            SFContentBlockerManager.reloadContentBlocker(withIdentifier: "Artem-Golikov.test-project-GTL.SocialNetwork")
        }
    }
}
