//
//  VideoFeedApp.swift
//  VideoFeed
//
//  Created by Herve Guigoz on 24/02/2022.
//

import SwiftUI
import AVFoundation

@main
struct VideoFeedApp: App {
    init() {
      setVideoPlaybackCategory()
    }
    
    var body: some Scene {
        WindowGroup {
            VideoFeedView()
        }
    }
    
    private func setMixWithOthersPlaybackCategory() {
      try? AVAudioSession.sharedInstance().setCategory(
        AVAudioSession.Category.ambient,
        mode: AVAudioSession.Mode.moviePlayback,
        options: [.mixWithOthers])
    }

    private func setVideoPlaybackCategory() {
      try? AVAudioSession.sharedInstance().setCategory(.playback)
    }
}
