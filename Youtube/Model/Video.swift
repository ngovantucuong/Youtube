//
//  Video.swift
//  Youtube
//
//  Created by ngovantucuong on 10/5/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class Video : NSObject {
    var title: String?
    var number_of_views: NSNumber?
    var thumbnail_image_name: String?
    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        
        self.title = dictionary["title"] as? String
        self.number_of_views = dictionary["number_of_views"] as? NSNumber
        self.thumbnail_image_name = dictionary["thumbnail_image_name"] as? String
        self.duration = dictionary["duration"] as? NSNumber
    }
    
}

class Channel: NSObject {
    var name: String?
    var profile_image_name: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        self.name = dictionary["name"] as? String
        self.profile_image_name = dictionary["profile_image_name"] as? String
    }
}
