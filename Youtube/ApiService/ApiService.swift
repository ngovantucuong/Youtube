//
//  ApiService.swift
//  Youtube
//
//  Created by ngovantucuong on 10/8/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class ApiService: NSObject {

    static let sharedInstance = ApiService()
    let baseFeed = "https://s3-us-west-2.amazonaws.com/youtubeassets"
    
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        let pathJson: String = "\(baseFeed)/home.json"
        fetchFeedForUrlString(urlString: pathJson, completion: completion)
    }
    
    func fetchTrendingFeed(completion: @escaping ([Video]) -> ()) {
        let pathJson: String = "\(baseFeed)/trending.json"
        fetchFeedForUrlString(urlString: pathJson, completion: completion)
    }
    
    func fetchSubcriptionFeed(completion: @escaping ([Video]) -> ()) {
        let pathJson: String = "\(baseFeed)/subscriptions.json"
        fetchFeedForUrlString(urlString: pathJson, completion: completion)
    }
    
    func fetchFeedForUrlString(urlString: String, completion: @escaping ([Video]) -> ()) {
        let pathJson: String = urlString
        let url = URL(string: pathJson)
        let urlRequest = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
            }
            
            do {
                if let unwrapData = data, let jsonDictionary = try JSONSerialization.jsonObject(with: unwrapData, options: []) as? [[String: AnyObject]] {
                    var videos = [Video]()
                    for dictionary in jsonDictionary {
                        let video = Video(dictionary: dictionary)
                
                        let chanelDictionary = dictionary["channel"] as! [String: AnyObject]
                        let chanel = Channel(dictionary: chanelDictionary)
                        video.channel = chanel
                        videos.append(video)
                    }
                    DispatchQueue.main.async {
                        completion(videos)
                    }
                }
            } catch {
                print("error try conversion data to json")
                return
            }
        })
        task.resume()
    }

    
}
