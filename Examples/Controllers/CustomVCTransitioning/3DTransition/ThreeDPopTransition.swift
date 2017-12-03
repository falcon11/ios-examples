//
//  ThreeDPopTransition.swift
//  Examples
//
//  Created by Ashoka on 03/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ThreeDPopTransition: NSObject, UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from) else { return }
        guard let toVC = transitionContext.viewController(forKey: .to) else { return }
        guard let fromView = fromVC.view else {
            return
        }
        guard let toView = toVC.view else {
            return
        }
        containerView.addSubview(toView)
        
        var transform = CATransform3DIdentity
        transform.m34 = -0.002
        containerView.layer.sublayerTransform = transform
        
        let initialFrame = transitionContext.initialFrame(for: fromVC)
        fromView.frame = initialFrame
        toView.frame = initialFrame
        print(initialFrame)
        
        toView.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        toView.layer.position = CGPoint(x: 0, y: UIScreen.main.bounds.midY)
        
        toView.layer.transform = CATransform3DMakeRotation(-CGFloat.pi/2, 0, 1, 0)
        print(toView.frame)
        
        let gradient = CAGradientLayer()
        gradient.frame = toView.bounds
        gradient.colors = [UIColor.init(white: 0, alpha: 0.5).cgColor, UIColor.init(white: 0, alpha: 0).cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.8, y: 0.5)
        let shadow = UIView(frame: toView.bounds)
        shadow.backgroundColor = UIColor.clear
        shadow.layer.addSublayer(gradient)
        shadow.alpha = 1
        toView.addSubview(shadow)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, options: .curveEaseOut, animations: {
            shadow.alpha = 0
            toView.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0)
        }) { (finished) in
            print(toView.frame)
            toView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            toView.layer.position = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            print(toView.frame)
            shadow.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
