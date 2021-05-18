//
//  Environment.swift
//  KidsFit
//
//  Created by Steven Yang on 5/11/21.
//

import Foundation

public enum Environment {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    static let rootDatabaseURL: String = {
        guard let rootURLstring = Environment.infoDictionary["ROOT_DATABASE_URL"] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        return rootURLstring
    }()
    
    static let rootStorageURL: String = {
      guard let rootURLstring = Environment.infoDictionary["ROOT_STORAGE_URL"] as? String else {
          fatalError("Root URL not set in plist for this environment")
      }
      return rootURLstring
    }()


  static let apiKey: String = {
    guard let apiKey = Environment.infoDictionary["API_KEY"] as? String else {
      fatalError("API Key not set in plist for this environment")
    }
    return apiKey
  }()
}
