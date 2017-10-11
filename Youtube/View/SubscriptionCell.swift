//
//  SubscriptionCell.swift
//  Youtube
//
//  Created by ngovantucuong on 10/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {
    
    override func fetchVideo() {
        ApiService.sharedInstance.fetchSubcriptionFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
