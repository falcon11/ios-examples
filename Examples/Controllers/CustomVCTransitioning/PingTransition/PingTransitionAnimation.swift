//
//  PingTransitionAnimation.swift
//  Examples
//
//  Created by Ashoka on 09/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class PingTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate {
    var isPush = true
    var transitionContext: UIViewControllerContextTransitioning! = nil
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.7
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        if self.isPush {
            self.pushAnimation()
        } else {
            self.popAnimation()
        }
    }
    
    func pushAnimation() -> Void {
        let fromVc = transitionContext.viewController(forKey: .from)! as! PingTransitionParentViewController
        let toVc = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView
        let button = fromVc.button!
        
        container.addSubview(toVc.view)
        
        let startMaskBP = UIBezierPath(ovalIn: button.frame)
        let finalPoint = CGPoint(x: button.center.x, y: fromVc.view.bounds.height - button.center.y)
        let radius = sqrt(finalPoint.x*finalPoint.x + finalPoint.y * finalPoint.y)
        let finalMaskBP = UIBezierPath(ovalIn: button.frame.insetBy(dx: -radius, dy: -radius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = finalMaskBP.cgPath
        toVc.view.layer.mask = maskLayer
        self.addCALayerAnimation(toLayer: maskLayer, startPath: startMaskBP.cgPath, endPath: finalMaskBP.cgPath, duration: self.transitionDuration(using: transitionContext), pop: false)
        
    }
    
    func popAnimation() -> Void {
        let fromVc = transitionContext.viewController(forKey: .from)! as! PingTransitionSubViewController
        let toVc = transitionContext.viewController(forKey: .to)!
        let container = transitionContext.containerView
        let button = fromVc.button!
        
        container.insertSubview(toVc.view, belowSubview: fromVc.view)
        
//        let finalMaskBP = UIBezierPath(ovalIn: button.frame)
        let finalPoint = CGPoint(x: button.center.x, y: fromVc.view.bounds.height - button.center.y)
        let radius = sqrt(finalPoint.x*finalPoint.x + finalPoint.y * finalPoint.y)
//        let startMaskBP = UIBezierPath(ovalIn: button.frame.insetBy(dx: -radius, dy: -radius))
//
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = finalMaskBP.cgPath
//        fromVc.view.layer.mask = maskLayer
        let maskView = UIView()
        maskView.backgroundColor = UIColor.white
        maskView.frame = CGRect(x: 0, y: 0, width: radius*2, height: radius*2)
        maskView.layer.cornerRadius = radius
        maskView.center = button.center
        fromVc.view.mask = maskView
//        not use calayer animation can also control the animation
        UIView.animate(withDuration: self.transitionDuration(using: self.transitionContext), animations: {
            maskView.frame = button.frame
            maskView.layer.cornerRadius = button.bounds.width / 2
        }) { (finished) in
            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        }
//        self.addCALayerAnimation(toLayer: maskLayer, startPath: startMaskBP.cgPath, endPath: finalMaskBP.cgPath, duration: self.transitionDuration(using: transitionContext), pop: true)
//        UIView.animate(withDuration: 0.3, animations: {
//            fromVc.view.frame = UIScreen.main.bounds.offsetBy(dx: UIScreen.main.bounds.width, dy: 0)
//        }) { (finished) in
//            self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
//        }
    }
    
    func addCALayerAnimation(toLayer:CALayer, startPath: CGPath, endPath: CGPath, duration: TimeInterval, pop: Bool) -> Void {
        let keyPath = pop ? "pop" : "push"
        let layerAnimation = CABasicAnimation(keyPath: "path")
        layerAnimation.fromValue = startPath
        layerAnimation.toValue = endPath
        layerAnimation.duration = duration
        layerAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        layerAnimation.delegate = self
        toLayer.add(layerAnimation, forKey: keyPath)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.transitionContext.completeTransition(!self.transitionContext.transitionWasCancelled)
        self.transitionContext.viewController(forKey: .from)?.view.layer.mask = nil
        self.transitionContext.viewController(forKey: .to)?.view.layer.mask = nil
    }
    
}
