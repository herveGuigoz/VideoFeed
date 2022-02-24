//
//  LoopingPlayerView.swift
//  VideoFeed
//
//  Created by Herve Guigoz on 24/02/2022.
//

import SwiftUI
import AVKit

struct LoopingPlayerView: UIViewRepresentable {
  class Coordinator: NSObject, AVPlayerViewControllerDelegate, AVPictureInPictureControllerDelegate {
    private let parent: LoopingPlayerView

    var pipController: AVPictureInPictureController? {
      didSet {
        pipController?.delegate = self
      }
    }

    init(_ parent: LoopingPlayerView) {
      self.parent = parent
    }

    func pictureInPictureController(_ pictureInPictureController: AVPictureInPictureController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
      parent.shouldOpenPiP = false
      completionHandler(true)
    }
  }

  let videoURLs: [URL]

  @Binding var rate: Float
  @Binding var volume: Float
  @Binding var shouldOpenPiP: Bool

  func updateUIView(_ uiView: LoopingPlayerUIView, context: Context) {
    uiView.setVolume(volume)
    uiView.setRate(rate)
    if shouldOpenPiP && context.coordinator.pipController?.isPictureInPictureActive == false {
      context.coordinator.pipController?.startPictureInPicture()
    } else if !shouldOpenPiP && context.coordinator.pipController?.isPictureInPictureActive == true {
      context.coordinator.pipController?.stopPictureInPicture()
    }
  }

  func makeUIView(context: Context) -> LoopingPlayerUIView {
    let view = LoopingPlayerUIView(urls: videoURLs)
    view.setVolume(volume)
    view.setRate(rate)

    context.coordinator.pipController = AVPictureInPictureController(playerLayer: view.playerLayer)

    return view
  }

  static func dismantleUIView(_ uiView: LoopingPlayerUIView, coordinator: ()) {
    uiView.cleanup()
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

final class LoopingPlayerUIView: UIView {
  private var player: AVQueuePlayer?
  private var token: NSKeyValueObservation?

  private var allURLs: [URL]

  var playerLayer: AVPlayerLayer {
    // swiftlint:disable:next force_cast
    layer as! AVPlayerLayer
  }

  override class var layerClass: AnyClass {
    return AVPlayerLayer.self
  }

  init(urls: [URL]) {
    allURLs = urls
    player = AVQueuePlayer()

    super.init(frame: .zero)

    addAllVideosToPlayer()

    playerLayer.player = player

    token = player?.observe(\.currentItem) { [weak self] player, _ in
      if player.items().count == 1 {
        self?.addAllVideosToPlayer()
      }
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func addAllVideosToPlayer() {
    for url in allURLs {
      let asset = AVURLAsset(url: url)
      let item = AVPlayerItem(asset: asset)
      player?.insert(item, after: player?.items().last)
    }
  }

  func setVolume(_ value: Float) {
    player?.volume = value
  }

  func setRate(_ value: Float) {
    player?.rate = value
  }

  func cleanup() {
    player?.pause()
    player?.removeAllItems()
    player = nil
  }
}

