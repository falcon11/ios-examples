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
        let toVc: MagicMoveCollectionVCCollectionViewController = transitionContext.viewController(forKey: .to)! as! MagicMoveCollectionVCCollectionViewController
        let fromVc: MagicMoveSubVC = transitionContext.viewController(forKey: .from)! as! MagicMoveSubVC

        let snapView = fromVc.imageView.snapshotView(afterScreenUpdates: false)
        snapView?.frame = transitionContext.containerView.convert(fromVc.imageView.frame, from: fromVc.view)
        
//        print("subviews:", transitionContext.containerView.subviews.contains(fromVc.view), transitionContext.initialFrame(for: fromVc))
        toVc.view.frame = transitionContext.finalFrame(for: toVc)
        
        transitionContext.containerView.insertSubview(toVc.view, belowSubview: fromVc.view)
        transitionContext.containerView.addSubview(snapView!)
        
        let cell: MagicMoveCollectionViewCell = toVc.collectionView?.cellForItem(at: toVc.selectedIndexPath) as! MagicMoveCollectionViewCell
        let snapViewFinalRect = transitionContext.containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
        
        fromVc.imageView.isHidden = true
        cell.imageView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            fromVc.view.alpha = 0
            snapView?.frame = snapViewFinalRect
        }) { (finished) in
            snapView?.removeFromSuperview()
            cell.imageView.isHidden = false
            fromVc.imageView.isHidden = false
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
