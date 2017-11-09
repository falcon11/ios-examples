//
//  PingTransitionUINavigationVCDelegate.swift
//  Examples
//
//  Created by Ashoka on 09/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

public protocol PingTransitionProtocol {
    var isInteract: Bool { get set }
    var interactiveTransition: UIPercentDrivenInteractiveTransition? { get set }
}

class PingTransitionUINavigationVCDelegate: NSObject, UINavigationControllerDelegate {
    
    var viewVcDict: Dictionary<UIScreenEdgePanGestureRecognizer, Any> = Dictionary()
    var currentVc: (UIViewController & PingTransitionProtocol)?
    
    func addPopGestureTo(vc: UIViewController) -> Void {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(popGestureAction(gesture:)))
        gesture.edges = .left
        vc.view.addGestureRecognizer(gesture)
        viewVcDict[gesture] = vc
    }
    
    @objc func popGestureAction(gesture: UIScreenEdgePanGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        let translation = gesture.translation(in: view)
        var progress = min(translation.x / view.bounds.width, 1)
        progress = max(progress, 0)
        
        guard var vc = viewVcDict[gesture] as? (UIViewController & PingTransitionProtocol) else {
            return
        }
        switch gesture.state {
        case .began:
            self.currentVc = vc
            vc.isInteract = true
            vc.navigationController?.popViewController(animated: true)
        case .changed:
            vc.interactiveTransition?.update(progress)
        case .cancelled, .ended:
            vc.isInteract = false
            if gesture.state == .ended && progress > 0.5 {
                vc.interactiveTransition?.finish()
            } else {
                vc.interactiveTransition?.cancel()
            }
            self.currentVc = nil
        default:
            break
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let vc = self.currentVc else {
            return nil
        }
        if vc.isKind(of: PingTransitionSubViewController.self) {
            let vc : PingTransitionSubViewController = vc as! PingTransitionSubViewController
            return vc.isInteract ? vc.interactiveTransition : nil
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push && fromVC.isKind(of: PingTransitionParentViewController.self) && toVC.isKind(of: PingTransitionSubViewController.self) {
            let pingTransition = PingTransitionAnimation()
            pingTransition.isPush = true
            return pingTransition
        } else if operation == .pop && toVC.isKind(of: PingTransitionParentViewController.self) {
            let pingTransition = PingTransitionAnimation()
            pingTransition.isPush = false
            return pingTransition
        }
        return nil
    }
    
}
