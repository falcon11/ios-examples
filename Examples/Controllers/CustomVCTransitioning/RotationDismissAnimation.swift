//
//  RotationDismissAnimation.swift
//  Examples
//
//  Created by Ashoka on 06/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class RotationDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        let initRect = transitionContext.initialFrame(for: fromVC!)
        let finalRect = initRect.offsetBy(dx: 0, dy: UIScreen.main.bounds.height)
        
        transitionContext.containerView.addSubview(toVC!.view)
        transitionContext.containerView.sendSubview(toBack: toVC!.view)
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveLinear, animations: {
            fromVC?.view.frame = finalRect
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}
