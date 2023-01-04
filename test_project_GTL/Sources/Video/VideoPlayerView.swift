//
//  VideoPlayerView.swift
//  test_project_GTL
//
//  Created by User on 30.12.2022.
//

import UIKit
import AVFoundation
import AVKit

class VideoPlayerView: UIView {

    var videoPlayerLayer: AVPlayerLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    func setPlayer() {
        if let layer = self.layer as? AVPlayerLayer {
            guard let videoPath = Bundle.main.path(forResource: "intro", ofType: "MP4") else {
                return
            }
            let videoPlayer = AVPlayer(url: URL(filePath: videoPath))
            videoPlayerLayer = AVPlayerLayer(player: videoPlayer)
            videoPlayer.externalPlaybackVideoGravity = .resizeAspectFill
            layer.addSublayer(videoPlayerLayer ?? AVPlayerLayer())
            videoPlayer.play()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        videoPlayerLayer?.frame = self.bounds
    }

}
