//
//  File.swift
//  Youtube
//
//  Created by ngovantucuong on 10/9/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class FeedCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellID = "cellID"
    var videos: [Video]?
    
    func fetchVideo() {
        ApiService.sharedInstance.fetchVideos(completion: {(video: [Video]) in
            self.videos = video
            self.collectionView.reloadData()
        })
    }
    
    override func setupViews() {
        super.setupViews()
        
        fetchVideo()
        addSubview(collectionView)
        addConstrainWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstrainWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: cellID)
    }
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return videos?.count ?? 0
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! VideoCell
            cell.video = videos?[indexPath.row]
            return cell
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let height: CGFloat = (frame.width - 16 - 16) * 9 / 16
            return CGSize(width: frame.width, height: height + 88)
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let videoLaucher = VideosLaucher()
        videoLaucher.showVideoPlayer()
    }
}
