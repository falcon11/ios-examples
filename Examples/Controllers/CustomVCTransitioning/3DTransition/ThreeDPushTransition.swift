//
//  ThreeDPushTransition.swift
//  Examples
//
//  Created by Ashoka on 03/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ThreeDPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        let toVC = transitionContext.viewController(forKey: .to)
        guard let fromView = fromVC.view else {
            return
        }
        guard let toView = toVC?.view else {
            return
        }
        containerView.addSubview(toView)
        containerView.sendSubview(toBack: toView)
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
        
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        fromView.frame = initialFrame
        toView.frame = initialFrame
        
        fromView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        fromView.layer.position = CGPoint(x: 0, y: UIScreen.main.bounds.midY)
        
        let gradient = CAGradientLayer()
        gradient.frame = fromView.bounds
        gradient.colors = [UIColor.init(white: 0, alpha: 0.5).cgColor, UIColor.init(white: 0, alpha: 0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.8, y: 0.5)
        let shadow = UIView(frame: fromView.bounds)
        shadow.backgroundColor = UIColor.clear
        shadow.layer.addSublayer(gradient)
        shadow.alpha = 0
        fromView.addSubview(shadow)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            shadow.alpha = 1
            fromView.layer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 1, 0)
        }) { (finished) in
            fromView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            fromView.layer.position = CGPoint(x: UIScreen.main.bounds.minX, y: UIScreen.main.bounds.minY)
            fromView.layer.transform = CATransform3DIdentity
            shadow.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
    

}
