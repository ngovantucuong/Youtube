//
//  Settings.swift
//  Youtube
//
//  Created by ngovantucuong on 10/7/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class SettingsCell: BaseCell {
    
//    override var isSelected: Bool {
//        didSet {
//            self.backgroundColor = isSelected ? UIColor.darkGray : UIColor.white
//            nameLabel.tintColor = isSelected ? UIColor.white : UIColor.black
//            iconImageView.tintColor = isSelected ? UIColor.white : UIColor.black
//        }
//    }
    
    override var isHighlighted: Bool {
        didSet {
            self.backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.tintColor = isHighlighted ? UIColor.white : UIColor.black
            iconImageView.tintColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name?.rawValue
            
            iconImageView.image = UIImage(named: (setting?.nameImage)!)?.withRenderingMode(.alwaysTemplate)
            iconImageView.tintColor = UIColor.darkGray
            self.backgroundColor = UIColor.white
        }
    }
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Setting"
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    let iconImageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "settings")
        imv.contentMode = .scaleAspectFill
        return imv
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(nameLabel)
        addSubview(iconImageView)
        
        addConstrainWithFormat(format: "H:|-8-[v0(30)]-8-[v1]|", views: iconImageView, nameLabel)
        addConstrainWithFormat(format: "V:|[v0]|", views: nameLabel)
        addConstrainWithFormat(format: "V:|-10-[v0(30)]-10-|", views: iconImageView)

    }
    
}

