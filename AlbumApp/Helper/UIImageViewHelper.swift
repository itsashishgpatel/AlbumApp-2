//
//  UIImageViewHelper.swift
//  AlbumApp
//
//  Created by Ashish Patel on 27/09/19.
//  Copyright © 2019 Ashish Patel. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString: String) {
        
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        self.image = UIImage(named: "Placeholder")
        
        guard let url = URL(string: urlString) else {
            return
        }
        // if not, download image from url
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let myError = error {
                print(myError)
                return
            }
            
            DispatchQueue.main.async {
                if let imgData = data, let image = UIImage(data: imgData) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}
