//
//  ViewController.swift
//  AVPlayer_Youtube_iOS
//
//  Created by Talka_Ying on 2017/7/8.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit
import AVFoundation

class AVLayerViewController: UIViewController {
    
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var playerLayer:AVPlayerLayer!
    var asset:AVAsset!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // get Source URL
        let filePath = Bundle.main.path(forResource: "video", ofType: "mp4")!
        let sourceURL = URL(fileURLWithPath: filePath)
        
        // set player
        asset = AVURLAsset(url: sourceURL)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem:playerItem)
        playerLayer = AVPlayerLayer(player:player)
        
        // set layer
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        playerLayer.contentsScale = UIScreen.main.scale
        self.view.layer.addSublayer(playerLayer)
        
        // add Observer
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove Observer
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        
        // release player
        player.pause()
        playerLayer.removeFromSuperlayer()
        playerLayer=nil
        player=nil
        playerItem=nil
        asset=nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let playerItem = object as! AVPlayerItem
        
        if keyPath == "loadedTimeRanges" {
            let t = self.availableDurationWithplayerItem(playerItem)
            print("loadrange ",t)
        }
        else if keyPath == "status" {
            if playerItem.status == AVPlayerItemStatus.readyToPlay {
                print("playerItem is ready")
                player.play()
            }
            else if playerItem.status == AVPlayerItemStatus.unknown {
                print("playerItem Unknown error")
            }
            else if playerItem.status == AVPlayerItemStatus.failed {
                print("playItem failed")
            }
        }
    }
    
    func availableDurationWithplayerItem(_ playerItem:AVPlayerItem) -> TimeInterval {
        
        let loadedTimeRange = playerItem.loadedTimeRanges
        let timeRange = loadedTimeRange.first!.timeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange.start)
        let durationSeconds = CMTimeGetSeconds(timeRange.duration)
        let result = startSeconds+durationSeconds
        return result
    }
}

