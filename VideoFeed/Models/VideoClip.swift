//
//  VideoClip.swift
//  VideoFeed
//
//  Created by Herve Guigoz on 24/02/2022.
//

import Foundation

struct VideoClip: Decodable {
  let fileName: String

  private enum CodingKeys: String, CodingKey {
    case fileName = "file_name"
  }
}

extension VideoClip {
  static var urls: [URL] {
    return VideoClip.fetchLocalVideos().compactMap {
      Bundle.main.url(forResource: $0.fileName, withExtension: "mp4")
    }
  }
}

extension VideoClip {
  static func fetchLocalVideos() -> [VideoClip] {
    return readJSON(fileName: "LocalVideoClips")
  }
}
