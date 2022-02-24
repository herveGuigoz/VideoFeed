//
//  Utils.swift
//  VideoFeed
//
//  Created by Herve Guigoz on 24/02/2022.
//

import Foundation

func readJSON<T: Decodable>(fileName: String) -> [T] {
  if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
    do {
      let data = try Data(contentsOf: url)
      return try JSONDecoder().decode([T].self, from: data)
    } catch {
      print("Failed decoding JSON file: \(fileName).")
      return []
    }
  }
  return []
}
