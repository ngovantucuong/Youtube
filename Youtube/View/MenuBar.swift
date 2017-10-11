//
//  MenuBar.swift
//  Youtube
//
//  Created by ngovantucuong on 9/17/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.rgd(red: 230, green: 32, blue: 31)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellID = "cellID"
    let imagesName = ["home", "trending", "subscriptions", "account"]
    var homeController: HomeController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellID)
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        
        backgroundColor = UIColor.rgd(red: 230, green: 32, blue: 31)
        addSubview(collectionView)
        addConstrainWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstrainWithFormat(format: "V:|[v0]|", views: collectionView)
        
        setupHorizontalBar()
    }
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    func setupHorizontalBar() {
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let x = CGFloat(indexPath.item) * frame.width / 4
//        horizontalBarLeftAnchorConstraint?.constant = x
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imagesName[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgd(red: 91, green: 14, blue: 13)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaseCell {
    
    let imageView: UIImageView = {
        let imv = UIImageView()
        imv.image = UIImage(named: "home")
        return imv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgd(red: 91, green: 14, blue: 13)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgd(red: 91, green: 14, blue: 13)
        }
    }
    
    override func setupViews() {
        addSubview(imageView)
        addConstrainWithFormat(format: "H:|-32-[v0(28)]", views: imageView)
        addConstrainWithFormat(format: "V:[v0(28)]", views: imageView)
    }
}
