//
//  YouTubeViewController.swift
//  AVPlayer_Youtube_iOS
//
//  Created by Talka_Ying on 2017/7/10.
//  Copyright © 2017年 Talka_Ying. All rights reserved.
//

import UIKit
import YouTubePlayer

class YouTubeViewController: UIViewController, YouTubePlayerDelegate {

    @IBOutlet var videoView:YouTubePlayerView!
    var currentTimer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //https://stackoverflow.com/questions/27159931/uiwebbrowserview-does-not-span-entire-uiwebview
        //rotation problem
        self.automaticallyAdjustsScrollViewInsets=false
        
        //https://developers.google.com/youtube/player_parameters
        videoView.playerVars = ["playsinline":1 as AnyObject,
                                "showinfo": 0 as AnyObject,
                                "controls": 0 as AnyObject
        ]
        
        videoView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //invalidate Timer
        self.invalidateTimer()

        //clear
        videoView.stop()
        videoView.clear()
    }
    
    @IBAction func onBtnPrevious(_ sender: UIButton) {
        videoView.previousVideo()
    }
   
    @IBAction func onBtnNext(_ sender: UIButton) {
        videoView.nextVideo()
    }
    
    @IBAction func onBtnPlay(_ sender: UIButton) {
        videoView.play()
    }
    
    @IBAction func onBtnPause(_ sender: UIButton) {
        self.invalidateTimer()
        videoView.pause()
    }

    @IBAction func onBtnLoadVideo(_ sender: UIButton) {
        self.invalidateTimer()
        videoView.loadVideoID("nqmgjYNRpk0")
    }
    
    @IBAction func onBtnLoadPlayList(_ sender: UIButton) {
        self.invalidateTimer()
        videoView.loadPlaylistID("RDPdjbRvvJAzg")
    }
    
    func invalidateTimer() {
        if (currentTimer != nil) {
            currentTimer.invalidate()
        }
    }
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        print("delegate- ",videoPlayer)
    }
    
    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        print("delegate- ",videoPlayer," State: ",playerState)
        
        if playerState == YouTubePlayerState.Playing {
            currentTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self](Timer) in
                if (self?.videoView.getCurrentTime() != nil ) {
                    print("CurrentTimer: ",(self?.videoView.getCurrentTime())!)
                }
            })
        }
    }
    
    func playerQualityChanged(_ videoPlayer: YouTubePlayerView, playbackQuality: YouTubePlaybackQuality) {
        print("delegate- ",videoPlayer," Quality: ",playbackQuality)
    }
}
