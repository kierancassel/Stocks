//
//  Environment.swift
//  Stocks
//
//  Created by Kieran Cassel on 09/12/2022.
//

import Foundation

public enum AppConfig {
    enum ConfigKey {
        static let apiURL = "API_URL"
        static let apiKey = "API_KEY"
  }

  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()

    static let apiURL: String = {
      guard let apiURL = AppConfig.infoDictionary[ConfigKey.apiURL] as? String else {
        fatalError("API URL not set in plist for this environment")
      }
      return apiURL
    }()

  static let apiKey: String = {
    guard let apiKey = AppConfig.infoDictionary[ConfigKey.apiKey] as? String else {
      fatalError("API Key not set in plist for this environment")
    }
    return apiKey
  }()
}
