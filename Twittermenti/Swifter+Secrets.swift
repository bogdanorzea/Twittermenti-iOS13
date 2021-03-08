//
//  SwifterHelper.swift
//  Twittermenti
//
//  Created by Bogdan Orzea on 2021-03-07.
//  Copyright © 2021 London App Brewery. All rights reserved.
//

import Foundation
import Swifter

extension Swifter {
    static func initializeWithApiKeys() -> Swifter {
        guard let filePath = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            fatalError("Couldn't find file 'Secrets.plist'.")
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let TWITTER_CONSUMER_KEY = plist?.object(forKey: "TWITTER_CONSUMER_KEY") as? String else {
            fatalError("Couldn't find key 'TWITTER_CONSUMER_KEY' in 'Secrets.plist'.")
        }
        guard let TWITTER_CONSUMER_SECRET = plist?.object(forKey: "TWITTER_CONSUMER_SECRET") as? String else {
            fatalError("Couldn't find key 'TWITTER_CONSUMER_SECRET' in 'Secrets.plist'.")
        }
        
        return Swifter(consumerKey: TWITTER_CONSUMER_KEY, consumerSecret: TWITTER_CONSUMER_SECRET)
    }
}
