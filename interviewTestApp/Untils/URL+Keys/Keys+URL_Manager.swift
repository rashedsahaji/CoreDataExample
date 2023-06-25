//
//  KeysManager.swift
//  interviewTestApp
//
//  Created by Rashed Sahajee on 24/06/23.
//

import Foundation
class KeysManager {
    private struct Constants {
        static let keysPlist = "Keys"
        static let urlPlist = "URLs"
        static let linkExtentions = "plist"
    }
    
    //MARK: - FOR API KEYS
    enum SecretKeys: String {
        var value : String {
            if let linkPath = Bundle.main.path(forResource: Constants.keysPlist, ofType: Constants.linkExtentions) {
                let nsDic = NSDictionary(contentsOfFile: linkPath)!
                let value = nsDic[self.rawValue] as? String
                return value ?? ""
            }
            return ""
        }
        case apiKey = "APIKEY"
    }
    
    //MARK: - FOR URLS
    enum URLs: String {
        var value: String {
            if let linkPath = Bundle.main.path(forResource: Constants.urlPlist, ofType: Constants.linkExtentions) {
                let nsDic = NSDictionary(contentsOfFile: linkPath)!
                let value = nsDic[self.rawValue] as? String
                return value ?? ""
            }
            return ""
        }
        var valueAsURL: URL? {
            if let linkPath = Bundle.main.path(forResource: Constants.urlPlist, ofType: Constants.linkExtentions) {
                let nsDic = NSDictionary(contentsOfFile: linkPath)!
                let value = nsDic[self.rawValue] as? String
                return URL(string: value ?? "")
            }
            return URL(string: "")
        }
        case apiBaseURL = "BASE_URL"
    }
}
