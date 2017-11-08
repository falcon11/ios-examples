//
//  PanToPop.swift
//  Examples
//
//  Created by Ashoka on 07/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

// pan from left edge to pop a viewcontroller

class PanToPop: NSObject {
    
    private weak var viewController: UIViewController?
    private var edgesGesture : UIScreenEdgePanGestureRecognizer!
    private var parentView: UIView? = nil
    
    public func addEdgesPanGestureTo(vc: UIViewController) -> Void {
        if edgesGesture == nil {
            edgesGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgesAction(gesture:)))
            edgesGesture.edges = .left
            vc.view.addGestureRecognizer(edgesGesture)
        }
        viewController = vc
        guard let index = vc.navigationController?.viewControllers.index(of: vc) else {
            return
        }
        if index > 0 {
            let parentVc = vc.navigationController?.viewControllers[index - 1]
            parentView = parentVc?.view.snapshotView(afterScreenUpdates: false)
        }
    }
    
    @objc func edgesAction(gesture: UIScreenEdgePanGestureRecognizer) {
        var progress = gesture.translation(in: viewController?.view).x / UIScreen.main.bounds.width
        progress = min(progress, 1)
        
        switch gesture.state {
        case .began:
            guard self.parentView != nil && viewController != nil else { return }
            let parentView = self.parentView!
            parentView.frame = (viewController?.view.superview?.bounds)!
            viewController?.view.superview?.addSubview(parentView)
            viewController?.view.superview?.sendSubview(toBack: parentView)
        case .changed:
            UIView.animate(withDuration: 0.01, animations: {
                self.viewController?.view.frame = (UIScreen.main.bounds.offsetBy(dx: max(0, progress)*UIScreen.main.bounds.width, dy: 0))
            })
        case .cancelled, .ended:
            if progress > 0.5 {
                UIView.animate(withDuration: TimeInterval(0.3*(1-progress)), animations: {
                    self.viewController?.view.frame = UIScreen.main.bounds.offsetBy(dx: UIScreen.main.bounds.width, dy: 0)
                }, completion: { (finished) in
                    self.viewController?.navigationController?.popViewController(animated: false)
                    self.parentView?.removeFromSuperview()
                })
            } else {
                UIView.animate(withDuration: TimeInterval(0.3*progress), animations: {
                    self.viewController?.view.frame = UIScreen.main.bounds
                }, completion: { (finished) in
                    self.parentView?.removeFromSuperview()
                })
            }
        default:
            break
        }
    }
    
}
