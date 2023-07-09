//
//  SettingsManager.swift
//  FakeNFT
//
//  Created by Konstantin Kirillov on 09.07.2023.
//

import Foundation

enum SortType: String {
    case sortByName
    case sortByCount
    
    static func getTypeByString(stringType: String) -> SortType {
        switch stringType {
        case "sortByName":
            return SortType.sortByName
        case "sortByCount":
            return SortType.sortByCount
        default:
            return SortType.sortByName
        }
    }
}

final class SettingsManager  {
    static let shared = SettingsManager()
    
    let userDefaults = UserDefaults.standard

    var sortCollectionsType: String? {
        get {
            userDefaults.string(forKey: Keys.sortType.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.sortType.rawValue)
        }
    }
    
    private enum Keys: String {
        case sortType
    }
}
