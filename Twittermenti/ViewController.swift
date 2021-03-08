//
//  ViewController.swift
//  Twittermenti
//
//  Created by Angela Yu on 17/07/2019.
//  Copyright © 2019 London App Brewery. All rights reserved.
//

import UIKit
import Swifter
import CoreML

class ViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sentimentLabel: UILabel!
    
    let tweetCount = 100
    
    let swifter = Swifter.initializeWithApiKeys()
    let config = MLModelConfiguration()
    var sentimentClassifier: TweetSentimentClassifier!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            sentimentClassifier = try TweetSentimentClassifier(configuration: config)
        } catch {
            fatalError("Could not create SentimentClasisifier model")
        }
    }
    
    @IBAction func predictPressed(_ sender: Any) {
        fetchTweets()
    }
    
    func fetchTweets() {
        guard let userInput = self.textField.text else {
            return
        }
        
        swifter.searchTweet(using: userInput, lang: "en", count: tweetCount, tweetMode: .extended, success: { (results, _) in
            var tweetArray = [TweetSentimentClassifierInput]()
            
            if let tweets = results.array {
                tweets.forEach { (tweet) in
                    if let tweetObj = tweet.object, let fullText = tweetObj["full_text"]?.string {
                        tweetArray.append(TweetSentimentClassifierInput(text: fullText))
                    }
                }
            }
            
            self.makePrediction(with: tweetArray)
            
        }, failure: { (error) in
            print("There was an error with the Twitter API Request: \(error)")
        })
    }
    
    func makePrediction(with tweets: [TweetSentimentClassifierInput]) {
        var sentimentScore = 0
        if let predictions = try? self.sentimentClassifier.predictions(inputs: tweets) {
            predictions.forEach { (prediction) in
                if prediction.label == "Pos" {
                    sentimentScore += 1
                } else if prediction.label == "Neg" {
                    sentimentScore -= 1
                }
            }
        }
        
        self.updateUI(with: 0)
    }
    
    func updateUI(with sentimentScore: Int) {
        var sentimentText = ""
        switch sentimentScore {
            case 20...:
                sentimentText = "😍"
            case 10..<20:
                sentimentText = "😊"
            case 0..<10:
                sentimentText = "😁"
            case 0:
                sentimentText = "😐"
            case -10..<0:
                sentimentText = "☹️"
            case -20..<(-10):
                sentimentText = "😡"
            default:
                sentimentText = "🤮"
        }
        
        self.sentimentLabel.text = sentimentText
    }
}

