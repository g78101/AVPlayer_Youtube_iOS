//
//  AVPlayerVIewController.swift
//  AVPlayer_Youtube_iOS
//
//  Created by Talka_Ying on 2017/7/10.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import YoutubeSourceParserKit

class AVPlayerVIewController: UIViewController,AVPlayerViewControllerDelegate {

    var asset:AVAsset!
    var player:AVPlayer!
    var playerItem:AVPlayerItem!
    var playerVC:AVPlayerViewController!
    var timeObserver:Any?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // source from device
//        let mpath = Bundle.main.path(forResource: "video", ofType: "mp4")!
//        let url = URL(fileURLWithPath:mpath)
        
        // source from url
//        let url = URL(string: "https://talkaying.ga/video/MORTAL-EX.mp4")!
        
        // source from youtube
        let url = URL(string: self.youtubeSourceParserTest("oJuB_DwQTDc"))!
        
        // set player
        asset = AVAsset(url:url)
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        
        // set AVPlayerView
        playerVC = AVPlayerViewController()
        playerVC.player=player
        playerVC.view.frame = CGRect(x: 0 ,y:100 ,width: 375 ,height: 500)
        self.view.addSubview(playerVC.view)
        
        // add Observer
        playerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: NSKeyValueObservingOptions.new, context: nil)
        playerItem.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) {  [weak self] time in
            let current = CMTimeGetSeconds(time)
            let total = CMTimeGetSeconds((self?.player.currentItem?.duration)!)
            
            print("now ",current)
            print("total ",total)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // remove Observer
        player.removeTimeObserver(timeObserver!)
        playerItem.removeObserver(self, forKeyPath: "loadedTimeRanges")
        playerItem.removeObserver(self, forKeyPath: "status")
        
        // release player
        player.pause()
        playerVC.view.removeFromSuperview()
        player=nil
        playerVC=nil
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
                print("playerItem Unknow error")
            }
            else if playerItem.status == AVPlayerItemStatus.failed {
                print("playItem failed ",playerItem.error!)
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

    func youtubeSourceParserTest(_ url:String) -> String {
        
        let videoInfo = Youtube.h264videosWithYoutubeID(url)
        print(videoInfo!)
        let videoUrl:String = videoInfo?["url"] as! String
        return videoUrl
    }
}
