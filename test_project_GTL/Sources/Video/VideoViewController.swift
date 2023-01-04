//
//  ViewController.swift
//  test_project_GTL
//
//  Created by User on 30.12.2022.
//

import UIKit
import AVFoundation
import AVKit
import SnapKit

enum Strings: String {
    case welcome = "Privet"

    var localizedString: String {
        NSLocalizedString(self.rawValue, comment: "")
    }
}

class VideoViewController: UIViewController {

    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.text = Strings.welcome.localizedString
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()

    private lazy var subTitle: UILabel = {
        let label = UILabel()
        label.text = "Перед началом работы включите \nрасширение iSecurity в настройках Safari"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var videoView = UIView()
    private lazy var videoView2 = VideoPlayerView()

    private lazy var descriptionTitle: UILabel = {
        let label = UILabel()
        label.text = "Настройки > Safari > Расширения \nи включите переключатель iSecurity"
        label.textColor = .systemGray2
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        videoView.backgroundColor = .white
    }

    func setPlayer() {
        let videoURL = URL(
            filePath: Bundle.main.path(
                forResource: "intro",
                ofType: "MP4"
            ) ?? ""
        )
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.view.frame = self.videoView.bounds
        playerViewController.player?.externalPlaybackVideoGravity = .resizeAspectFill
        playerViewController.view.backgroundColor = .white
        playerViewController.player?.play()
        self.videoView.addSubview(playerViewController.view)
        self.addChild(playerViewController)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setPlayer()
    }

    private func setupHierarchy() {
        view.addSubview(mainTitle)
        view.addSubview(subTitle)
        view.addSubview(videoView)
        view.addSubview(descriptionTitle)
        view.addSubview(videoView2)
    }

    private func setupLayout() {
        mainTitle.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.25)
        }

        subTitle.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.35)
        }


        videoView.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(0.7)
            make.width.equalTo(view.snp.width).multipliedBy(0.85)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        }

        descriptionTitle.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.08)
        }

        videoView2.snp.makeConstraints { make in
            make.centerX.equalTo(view.snp.centerX)
            make.centerY.equalTo(view.snp.centerY).multipliedBy(1.5)
            make.width.equalTo(view.snp.width).multipliedBy(0.85)
            make.height.equalTo(view.snp.height).multipliedBy(0.2)
        }
    }
}

