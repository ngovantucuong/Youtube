//
//  Extension.swift
//  Youtube
//
//  Created by ngovantucuong on 9/17/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgd (red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}

extension UIView {
    func addConstrainWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let index = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[index] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

class CustomImageView: UIImageView {
    var cache = NSCache<AnyObject, AnyObject>()
    
    func loadImageUsingUrlString(urlString: String) {
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {(data, response, error) in
            if error != nil {
                print("load image faile")
                return
            }
            
            if let imageFromCache = self.cache.object(forKey: urlString as AnyObject) {
                DispatchQueue.main.async {
                    self.image = imageFromCache as? UIImage
                }
            }
            else
            {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                    self.cache.setObject(UIImage(data: data!)!, forKey: urlString as AnyObject)
                }
            }
        }).resume()
    }
}
