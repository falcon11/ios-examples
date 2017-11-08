//
//  MagicMoveAnimation.swift
//  Examples
//
//  Created by Ashoka on 07/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class MagicMoveAnimation: NSObject, UIViewControllerAnimatedTransitioning{

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVc : MagicMoveCollectionVCCollectionViewController = transitionContext.viewController(forKey: .from) as! MagicMoveCollectionVCCollectionViewController
        let toVc : MagicMoveSubVC = transitionContext.viewController(forKey: .to) as! MagicMoveSubVC
        let containerView = transitionContext.containerView
        
        fromVc.selectedIndexPath = fromVc.collectionView?.indexPathsForSelectedItems?.first
        let cell : MagicMoveCollectionViewCell = fromVc.collectionView?.cellForItem(at: fromVc.selectedIndexPath!) as! MagicMoveCollectionViewCell
        
        let imageView = cell.imageView.snapshotView(afterScreenUpdates: false)
        imageView?.frame = containerView.convert(cell.imageView.frame, from: cell.imageView.superview)
        
        toVc.view.frame = transitionContext.finalFrame(for: toVc)
        
        containerView.addSubview(toVc.view)
        containerView.addSubview(imageView!)
        
        cell.imageView.isHidden = true
        toVc.view.alpha = 0
        toVc.imageView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
            toVc.view.alpha = 1
            imageView?.frame = containerView.convert(toVc.imageView.frame, from: toVc.imageView.superview)
        }) { (finished) in
            cell.imageView.isHidden = false
            toVc.imageView.isHidden = false
            imageView?.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}
