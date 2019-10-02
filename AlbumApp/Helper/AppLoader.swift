//
//  AppLoader.swift
//  AlbumApp
//
//  Created by Ashish Patel on 27/09/19.
//  Copyright © 2019 Ashish Patel. All rights reserved.
//

import UIKit

class AppLoader: UIView {

    let loaderView = UIActivityIndicatorView()
    let loaderText = UILabel()
    
    override init(frame: CGRect) {
    
    super.init(frame: frame)
        
        loaderView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        loaderView.style = .gray
        loaderView.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        self.addSubview(loaderView)
        
        loaderText.frame = CGRect(x: 20, y: loaderView.frame.origin.y + loaderView.frame.size.height + 10, width: frame.size.width - 40, height: 0)
        loaderText.numberOfLines = 0;
        loaderText.lineBreakMode = .byWordWrapping
        loaderText.textColor = .black
        loaderText.font = UIFont.boldSystemFont(ofSize: 15)
        loaderText.textAlignment = .center
        self.addSubview(loaderText)
        
        self.backgroundColor = .white
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLogoAnimation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.y")
        animation.toValue = NSNumber(value: Double.pi * 2)
        animation.duration = 1
        animation.isCumulative = true
        animation.repeatCount = Float(Int.max)
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        return animation
    }
    
    func showLoaderWithMessage(_ message: String) {
        self.tag = AppConstant.loaderTag
        
        loaderView.startAnimating()
        loaderText.text = message
         
        loaderText.sizeToFit()
        loaderText.center = CGPoint(x: self.center.x, y: loaderText.center.y)
    }
    
    class func hideLoaderIn(_ view: UIView) {
        DispatchQueue.main.async {
            if let loader = view.viewWithTag(AppConstant.loaderTag) as? AppLoader {
                UIView.animate(withDuration: 0.25, animations: {
                    loader.alpha = 0
                }, completion: {(success) in
                    loader.removeFromSuperview()
                })
            }
        }
    }
    
    class func showErrorIn(view: UIView, withMessage message: String) {
        DispatchQueue.main.async {

            if let loader = view.viewWithTag(AppConstant.loaderTag) as? AppLoader {
                
                loader.loaderView.stopAnimating()
                loader.loaderText.text = message
                
                loader.loaderText.frame.origin.x = 20
                loader.loaderText.frame.size.width = loader.frame.size.width - 40
                loader.loaderText.sizeToFit()
                loader.loaderText.center = CGPoint(x: loader.bounds.size.width/2, y: loader.bounds.size.height/2)
            }
        }
    }
}

struct AppConstant {
    static let loaderTag = 23456
}
