//
//  MagicMoveInverseTransition.swift
//  Examples
//
//  Created by Ashoka on 07/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class MagicMoveInverseTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVc = transitionContext.viewController(forKey: .to)!
        let fromVc = transitionContext.viewController(forKey: .from)!
        let initFrame = transitionContext.initialFrame(for: fromVc)
        let fromVcFinalRect = initFrame.offsetBy(dx: UIScreen.main.bounds.width, dy: 0)
        
        print("subviews:", transitionContext.containerView.subviews.contains(fromVc.view), transitionContext.initialFrame(for: fromVc))
        toVc.view.frame = transitionContext.finalFrame(for: toVc)
        transitionContext.containerView.addSubview(toVc.view)
        transitionContext.containerView.sendSubview(toBack: toVc.view)
        
        UIView.animate(withDuration: 0.3, animations: {
            fromVc.view.frame = fromVcFinalRect
        }) { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
