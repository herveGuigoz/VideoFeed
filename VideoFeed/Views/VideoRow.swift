//
//  VideoRow.swift
//  VideoFeed
//
//  Created by Herve Guigoz on 24/02/2022.
//

import SwiftUI

struct VideoRow: View {
  let video: Video

  private let imageHeight: CGFloat = 250
  private let imageCornerRadius: CGFloat = 12.0

  var body: some View {
    VStack(alignment: .leading) {
      Text(video.title)
        .font(.title2)

        Text(video.fileName)
        .font(.subheadline)
    }
    .padding(.vertical)
  }
}

struct VideoRow_Previews: PreviewProvider {
  static var previews: some View {
    VideoRow(video: Video.fetchRemoteVideos()[0])
  }
}
