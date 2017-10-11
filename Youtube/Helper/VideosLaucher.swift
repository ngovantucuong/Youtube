//
//  VideosLaucher.swift
//  Youtube
//
//  Created by ngovantucuong on 10/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let controlsContainerView: UIView = {
        let ct = UIView()
        ct.backgroundColor = UIColor(white: 0, alpha: 1)
        return ct
    }()
    
    let pausePlayButton: UIButton = {
        let bt = UIButton()
        let image = UIImage(named: "pause")
        bt.setImage(image, for: .normal)
        bt.isHidden = true
        bt.translatesAutoresizingMaskIntoConstraints = false
        bt.tintColor = UIColor.white
        bt.addTarget(self, action: #selector(handlerPause), for: .touchUpInside)
        return bt
    }()
    
    let videoLengthlabel: UILabel = {
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.textAlignment = .right
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let currentTimelabel: UILabel = {
        let lb = UILabel()
        lb.text = "00:00"
        lb.textColor = UIColor.white
        lb.font = UIFont.boldSystemFont(ofSize: 13)
        lb.textAlignment = .left
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let videoSilder: UISlider = {
        let sl = UISlider()
        sl.maximumTrackTintColor = UIColor.white
        sl.minimumTrackTintColor = UIColor.red
        sl.setThumbImage(UIImage(named: "thumb"), for: .normal)
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return sl
    }()
    
    @objc func handleSliderChange () {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSilder.value) * totalSeconds
            let seek = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seek, completionHandler: { (seekComplete) in
                
            })
        }
    }
    
    var isplayer:Bool = false
    @objc func handlerPause() {
        if isplayer {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isplayer = !isplayer
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthlabel)
        videoLengthlabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthlabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoLengthlabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthlabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimelabel)
        currentTimelabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimelabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        currentTimelabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimelabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
       
        controlsContainerView.addSubview(videoSilder)
        videoSilder.rightAnchor.constraint(equalTo: videoLengthlabel.leftAnchor).isActive = true
        videoSilder.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSilder.leftAnchor.constraint(equalTo: currentTimelabel.rightAnchor).isActive = true
        videoSilder.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = UIColor.black
    }
    
    var player: AVPlayer?
    private func setupPlayerView() {
        let urlString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            //playerLayer.frame = self.frame
            playerLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 3.0 / 4.0)
            self.layer.addSublayer(playerLayer)
            
            player?.play()
            player?.addObserver(self, forKeyPath: "timeLoadRange", options: .new, context: nil)
            
            let interval = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (processTime) in
                let seconds = CMTimeGetSeconds(processTime)
                let secondsString = String(format: "%02d", Int64(seconds) % 60)
                let minutesString = String(format: "%02d", Int64(seconds) / 60)
                
                self.currentTimelabel.text = "\(minutesString):\(secondsString)"
                
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    
                    let value = Float(seconds / durationSeconds)
                    self.videoSilder.value = value
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeLoadRange" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = UIColor.clear
            pausePlayButton.isHidden = false
            isplayer = true
            
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                
                let secondText = Int64(seconds) % 60
                let minutesText = Int64(seconds) / 60
                videoLengthlabel.text = "\(String(format: "%02d", minutesText)):\(secondText)"
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class VideosLaucher: NSObject {
    
    func showVideoPlayer() {
        if let window = UIApplication.shared.keyWindow {
            let view = UIView(frame: window.frame)
            view.backgroundColor = UIColor.white
            view.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10)
            
            // 16 * 9 is aspect ratio of HD video
            let heightVideoFrame = window.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: heightVideoFrame)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            window.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                view.frame = window.frame
            }, completion: { (complete) in
                UIApplication.shared.isStatusBarHidden = true
            })
            
        }
    }
}
