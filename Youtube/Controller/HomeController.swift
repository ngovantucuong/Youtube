//
//  ViewController.swift
//  Youtube
//
//  Created by ngovantucuong on 9/6/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let cellID = "cellID"
    let trendingId = "trendingID"
    let subcriptionID = "subcriptionID"
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "Home"
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        
        setupCollectionView()
        setupMenuBar()
        setupNavBarButtons()
    }
    
    func setupCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subcriptionID)
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
        
        collectionView?.isPagingEnabled = true
    }
    
    func setupNavBarButtons() {
        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
            , style: .plain, target: self, action: #selector(handleSearch))
        
        let moreButton = UIBarButtonItem(image: UIImage(named: "nav_more_icon")
            , style: .plain, target: self, action: #selector(handleMore))
        moreButton.tintColor = UIColor.white
        
        navigationItem.rightBarButtonItems = [searchBarButtonItem, moreButton]
    }
    
    @objc func handleSearch() {
        
    }
    
    lazy var settingsLaucher: SettingsLaucher = {
        let launcher = SettingsLaucher()
        launcher.homeController = self
        return launcher
    }()
    
    // show menu more
    @objc func handleMore() {
        settingsLaucher.showSettings()
    }
    
    func showControllerForSettings(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name?.rawValue
        dummySettingsViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.red]
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    private func setTitleForIndex(index: Int) {
        if let titleLabel = navigationItem.titleView as? UILabel {
            titleLabel.text = "  \(titles[index])"
        }
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        view.addSubview(menuBar)
        view.addConstrainWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstrainWithFormat(format: "V:[v0(110)]", views: menuBar)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexpath = NSIndexPath(item: menuIndex, section: 0) as  IndexPath
        collectionView?.scrollToItem(at: indexpath, at: .left, animated: true)
        
        setTitleForIndex(index: menuIndex)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: .centeredVertically)
        
        setTitleForIndex(index: Int(index))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var indentifier: String!
        
        if indexPath.item == 1 {
            indentifier = trendingId
        } else if indexPath.item == 2 {
            indentifier = subcriptionID
        } else {
            indentifier = cellID
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: indentifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}






