//
//  PageView.swift
//  Examples
//
//  Created by Ashoka on 04/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit
import pop

class PageView: UIView {
    
    var topView : UIImageView!
    var bottomView : UIImageView!
    let image = UIImage(named: "cat")!
    var initialLocation = CGFloat(0)
    var topShadowLayer : CAGradientLayer!
    var bottomShadowLayer: CAGradientLayer!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addTopView()
        self.addBottomView()
        self.addGesture()
    }
    
    func addTopView() {
        topView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height/2))
        topView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
        topView.layer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        topView.layer.transform = setTransform3D()
        topView.contentMode = .scaleAspectFill
        topView.image = cutImageWith(id: "top")
        topView.isUserInteractionEnabled = true
        
        topShadowLayer = CAGradientLayer()
        topShadowLayer.frame = topView.bounds
        topShadowLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        topShadowLayer.opacity = 0
        topView.layer.addSublayer(topShadowLayer)
        
        self.addSubview(topView)
    }
    
    func addBottomView() {
        bottomView = UIImageView(frame: CGRect(x: 0, y: self.bounds.height/2, width: self.bounds.width, height: self.bounds.height/2))
        bottomView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        bottomView.layer.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        bottomView.layer.transform = setTransform3D()
        bottomView.contentMode = .scaleAspectFill
        bottomView.image = cutImageWith(id: "bottom")
        bottomView.isUserInteractionEnabled = true
        
        bottomShadowLayer = CAGradientLayer()
        bottomShadowLayer.frame = bottomView.bounds
        bottomShadowLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        bottomShadowLayer.opacity = 0
        bottomView.layer.addSublayer(bottomShadowLayer)
        
        self.addSubview(bottomView)
    }
    
    func addGesture() {
        let pan1 = UIPanGestureRecognizer(target: self, action: #selector(topPan(recognizer:)))
        topView.addGestureRecognizer(pan1)
        
        let pan2 = UIPanGestureRecognizer(target: self, action: #selector(bottomPan(recognizer:)))
        bottomView.addGestureRecognizer(pan2)
    }
    
    func recover(view: UIView) {
        let recoverAnimation = POPSpringAnimation(propertyNamed: kPOPLayerRotationX)
        recoverAnimation?.springBounciness = 18
        recoverAnimation?.dynamicsMass = 2.0
        recoverAnimation?.dynamicsTension = 200
        recoverAnimation?.toValue = 0
        view.layer.pop_add(recoverAnimation, forKey: "recoverAnimation")
        self.topShadowLayer.opacity = 0
        self.bottomShadowLayer.opacity = 0
    }
    
    @objc func topPan(recognizer: UIPanGestureRecognizer) -> Void {
        let location = recognizer.location(in: self)
        if recognizer.state == .began {
            self.initialLocation = location.y
            self.bringSubview(toFront: self.topView)
        }
        
        if (self.topView.layer.value(forKeyPath: "transform.rotation.x") as! CGFloat) < -CGFloat.pi/2 {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.topShadowLayer.opacity = 0
            self.bottomShadowLayer.opacity = Float((location.y - self.initialLocation)/(self.bounds.height - self.initialLocation))
            print(Float((location.y - self.initialLocation)/(self.bounds.height - self.initialLocation)))
            CATransaction.commit()
        } else {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.topShadowLayer.opacity = Float((location.y - self.initialLocation)/(self.bounds.height - self.initialLocation))
            self.bottomShadowLayer.opacity = Float((location.y - self.initialLocation)/(self.bounds.height - self.initialLocation))
            CATransaction.commit()
        }
        
        if isLocation(location: location, inView: self) {
            let percent = -CGFloat.pi / (self.bounds.height - self.initialLocation)
            let rotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotationX)
            rotationAnimation?.duration = 0.01
            rotationAnimation?.toValue = (location.y - self.initialLocation) * percent
            self.topView.layer.pop_add(rotationAnimation, forKey: "rotationAnimation")
            
            if recognizer.state == .ended || recognizer.state == .cancelled {
                self.recover(view: self.topView)
            }
        }
        
        if location.y < 0 || (location.y - self.initialLocation) > (self.bounds.height - self.initialLocation) || location.x < 0 || location.x > self.bounds.width {
            self.recover(view: self.topView)
        }
        
    }
    
    @objc func bottomPan(recognizer: UIPanGestureRecognizer) -> Void {
        let location = recognizer.location(in: self)
        if recognizer.state == .began {
            self.initialLocation = location.y
            self.bringSubview(toFront: self.bottomView)
        }
        
        if (self.bottomView.layer.value(forKeyPath: "transform.rotation.x") as! CGFloat) > CGFloat.pi/2 {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.topShadowLayer.opacity = Float((self.initialLocation - location.y)/(self.initialLocation))
            self.bottomShadowLayer.opacity = 0
            print(Float((self.initialLocation - location.y)/(self.initialLocation)))
            CATransaction.commit()
        } else {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            self.topShadowLayer.opacity = Float((self.initialLocation - location.y)/(self.initialLocation))
            self.bottomShadowLayer.opacity = Float((self.initialLocation - location.y)/(self.initialLocation))
            print("b", Float((self.initialLocation - location.y)/(self.initialLocation)))
            CATransaction.commit()
        }
        
        if isLocation(location: location, inView: self) {
            let percent = -CGFloat.pi / self.initialLocation
            let rotationAnimation = POPBasicAnimation(propertyNamed: kPOPLayerRotationX)
            rotationAnimation?.duration = 0.01
            rotationAnimation?.toValue = (location.y - self.initialLocation) * percent
            self.bottomView.layer.pop_add(rotationAnimation, forKey: "rotationAnimation")
            
            if recognizer.state == .ended || recognizer.state == .cancelled {
                self.recover(view: self.bottomView)
            }
        }
        
        if location.y < 0 || (location.y - self.initialLocation) > (self.bounds.height - self.initialLocation) || location.x < 0 || location.x > self.bounds.width {
            self.recover(view: self.bottomView)
        }
    }
    
    func setTransform3D() -> CATransform3D {
        var transform = CATransform3DIdentity
        transform.m34 = 2.5/(-2000)
        return transform
    }
    
    func cutImageWith(id: String) -> UIImage {
        var rect = CGRect(x: 0, y: 0, width: self.image.size.width, height: self.image.size.height/2)
        if id == "bottom" {
            rect.origin.y = self.image.size.height/2
        }
        let cgimage = self.image.cgImage?.cropping(to: rect)
        let image = UIImage(cgImage: cgimage!)
        return image
    }
    
    func isLocation(location: CGPoint, inView view: UIView) -> Bool {
        if location.x > 0 && location.x < view.bounds.width && location.y > 0 && location.y < view.bounds.height {
            return true
        }
        return false
    }

}
