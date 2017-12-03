//
//  PopInteractiveTransition.swift
//  Examples
//
//  Created by Ashoka on 03/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ThreeDPopInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var isInteracting: Bool = false
    weak var presentedVC: UIViewController!
    
    func addPopGestureTo(vc: UIViewController) {
        presentedVC = vc
        let popGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeGestureAction(gesture:)))
        // if not set edges, this gesture has no effect
        popGesture.edges = .left
        presentedVC.view.addGestureRecognizer(popGesture)
        print(presentedVC.view)
    }
    
    @objc func edgeGestureAction(gesture: UIScreenEdgePanGestureRecognizer) {
        let x = gesture.translation(in: presentedVC.view).x
        var progress = x / presentedVC.view.bounds.width
        progress = max(progress, 0)
        progress = min(progress, 1)
        
        switch gesture.state {
        case .began:
            isInteracting = true
            presentedVC.navigationController?.popViewController(animated: true)
        case .changed:
            self.update(progress)
        case .cancelled, .ended:
            isInteracting = false
            if progress > 0.5 {
                self.finish()
            } else {
                self.cancel()
            }
        default:
            break
        }
    }
}
