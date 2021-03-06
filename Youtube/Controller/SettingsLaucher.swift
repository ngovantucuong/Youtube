//
//  SettingsLaucher.swift
//  Youtube
//
//  Created by ngovantucuong on 10/7/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class Setting: NSObject {
    let name: SettingName?
    let nameImage: String?
    
    init(name: SettingName, nameImage: String) {
        self.name = name
        self.nameImage = nameImage
    }
}

enum SettingName: String {
    case Cancel = "Cancel"
    case Settings = "Settings"
    case TermsPrivacy = "Terms Privacy"
    case SendFeedback = "Send Feedback"
    case Help = "Help"
    case SwitchAccount = "Switch Account"
}

class SettingsLaucher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    let cellID = "cellID"
    let cellHeight: CGFloat = 50
    var homeController: HomeController?
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let backView = UIView()
    
    let settings: [Setting] = {
        return [Setting(name: .Settings, nameImage: "settings"),
                Setting(name: .TermsPrivacy, nameImage: "privacy"),
                Setting(name: .SendFeedback, nameImage: "feedback"),
                Setting(name: .SwitchAccount, nameImage: "switch_account"),
                Setting(name: .Help, nameImage: "help"),
                Setting(name: .Cancel, nameImage: "cancel")]
    }()
    
    // show menu more
    func showSettings() {
        if let window = UIApplication.shared.keyWindow {
            backView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(backView)
            window.addSubview(collectionView)
            
            let height: CGFloat = CGFloat(settings.count) * cellHeight
            let y: CGFloat = window.frame.height - height
            
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            backView.frame = window.frame
            backView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backView.alpha = 1
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
    }
    
    @objc func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backView.alpha = 0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (complete: Bool) in
            if setting.name != .Cancel {
                self.homeController?.showControllerForSettings(setting: setting)
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? SettingsCell
        cell?.setting = settings[indexPath.item]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
}
