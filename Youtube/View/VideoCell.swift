//
//  VideoCell.swift
//  Youtube
//
//  Created by ngovantucuong on 9/17/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoCell: BaseCell{
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
            
            setupThumbnailImage()
            setupProfileImage()
            
            if let channelName = video?.channel?.name, let numberOfView = video?.number_of_views {
               let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                
                let subtitleText = "\(channelName) • \(numberFormatter.string(from: numberOfView) ?? "0") • 2 years ago"
                subtitleTextView.text = subtitleText
            }
            
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 - 44 - 8 - 16, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
                let estimatedRect = NSString(string: title).boundingRect(with: size,
                                                                         options: options,
                                                                         attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)], context: nil)
                if estimatedRect.height > 20 {
                   titleLabelHeightConstraint?.constant = 44
                }
                else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnail_image_name {
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profile_image_name {
            userProfileImageView.loadImageUsingUrlString(urlString: profileImageUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_blank_space")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.image = UIImage(named: "taylor_swift_profile")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 0
        return label
    }()
    
    let subtitleTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "TaylorSwiftVEV0 - 1,604,684,607 views . 2 years"
        textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgd(red: 230, green: 230, blue: 230)
        return view
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?

    override func setupViews() {
        addSubview(thumbnailImageView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
        addSubview(separatorView)
        
        //Horizontal
        addConstrainWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstrainWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        // Vertical
        addConstrainWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-36-[v2(1)]|", views: thumbnailImageView,
                               userProfileImageView, separatorView)
        
        
        // TitleLabel Top
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
        // Left
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // Right
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        // Height
//        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal
//            , toItem: self, attribute: .height, multiplier: 0, constant: 20))
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        // SubtextView Top
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 8))
        // Left
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // Right
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        // Height
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal
            , toItem: self, attribute: .height, multiplier: 0, constant: 20))
        
        addConstrainWithFormat(format: "H:|[v0]|", views: separatorView)
    }
}

