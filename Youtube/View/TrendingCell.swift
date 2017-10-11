//
//  TrendingCell.swift
//  Youtube
//
//  Created by ngovantucuong on 10/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {
    
    override func fetchVideo() {
        ApiService.sharedInstance.fetchTrendingFeed { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }
}
