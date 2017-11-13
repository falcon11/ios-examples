//
//  PanInteractiveTransition.swift
//  Examples
//
//  Created by Ashoka on 06/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class PanInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var presentedVC : UIViewController!
    var isInteracting: Bool = false
    var critical : Bool = false
    var threshold: CGFloat = UIScreen.main.bounds.height*2/3
    
    public func panToDismiss(vc: UIViewController) {
        presentedVC = vc
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panAction(gesture:)))
        vc.view.addGestureRecognizer(panGesture)
        print("presented view", vc)
    }
    
    @objc func panAction(gesture: UIPanGestureRecognizer) {
        let transition = gesture.translation(in: self.presentedVC.view)
//        print(transition)
        switch gesture.state {
        case .began:
            self.isInteracting = true
            self.presentedVC.dismiss(animated: true, completion: nil)
            break
        case .changed:
            let percent = (transition.y/self.threshold) < 1 ? (transition.y/self.threshold):1
            self.critical = percent > 0.5
            print("percent", percent)
            self.update(percent)
            break
        case .cancelled, .ended:
            self.isInteracting = false
            if (gesture.state == .cancelled || !self.critical) {
                self.cancel()
            } else {
                self.finish()
            }
            self.critical = false
            break
        default:
            break
        }
    }
}
