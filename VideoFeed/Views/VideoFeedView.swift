//
//  VideoFeedView.swift
//  VideoFeed
//
//  Created by Herve Guigoz on 24/02/2022.
//

import SwiftUI
import AVKit

struct VideoFeedView: View {
  private let videos = Video.fetchRemoteVideos()
  private let videoClips = VideoClip.urls

  @State private var selectedVideo: Video?

  @State private var embeddedVideoRate: Float = 0.0
  @State private var embeddedVideoVolume: Float = 0.0
  @State private var shouldShowEmbeddedVideoInPiP = false

  var body: some View {
    NavigationView {
      List {
//        makeEmbeddedVideoPlayer()
        ForEach(videos) { video in
          Button {
            selectedVideo = video
          } label: {
            VideoRow(video: video)
          }
        }
      }
      .navigationTitle("Videos")
    }
    .fullScreenCover(item: $selectedVideo) {
      embeddedVideoRate = 1.0
    } content: { item in
      makeFullScreenVideoPlayer(for: item)
    }
  }

  @ViewBuilder
  private func makeFullScreenVideoPlayer(for video: Video) -> some View {
      let avPlayer = AVPlayer(url: video.videoURL)
      VideoPlayerView(player: avPlayer)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
          embeddedVideoRate = 0.0
            avPlayer.play()
        }
  }

  private func makeEmbeddedVideoPlayer() -> some View {
    HStack {
      Spacer()
      
      LoopingPlayerView(
        videoURLs: videoClips,
        rate: $embeddedVideoRate,
        volume: $embeddedVideoVolume,
        shouldOpenPiP: $shouldShowEmbeddedVideoInPiP)
        .background(Color.black)
        .frame(width: 250, height: 140)
        .cornerRadius(8)
        .shadow(radius: 4)
        .padding(.vertical)
        .onAppear {
          embeddedVideoRate = 1
        }
        .onTapGesture(count: 2) {
          embeddedVideoRate = embeddedVideoRate == 1.0 ? 2.0 : 1.0
        }
        .onTapGesture {
          embeddedVideoVolume = embeddedVideoVolume == 1.0 ? 0.0 : 1.0
        }
        .onLongPressGesture {
          shouldShowEmbeddedVideoInPiP.toggle()
        }
      
      Spacer()
    }
  }
}

struct VideoFeedView_Previews: PreviewProvider {
  static var previews: some View {
    VideoFeedView()
  }
}
