//
//  RotationPresentAnimation.swift
//  Examples
//
//  Created by Ashoka on 05/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class RotationPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toVC = transitionContext.viewController(forKey: .to) else {
            return
        }
        let finalRect = transitionContext.finalFrame(for: toVC)
        toVC.view.frame = finalRect.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        transitionContext.containerView.addSubview(toVC.view)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveLinear, animations: {
            toVC.view.frame = finalRect
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    

}
