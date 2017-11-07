//
//  PanToPop.swift
//  Examples
//
//  Created by Ashoka on 07/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class PanToPop: NSObject {
    
    private weak var _viewController: UIViewController?
    private var _edgesGesture : UIScreenEdgePanGestureRecognizer!
    public var percentDriveTransition: UIPercentDrivenInteractiveTransition!
    public var inverseTransition: MagicMoveInverseTransition! = MagicMoveInverseTransition()
    
    public func addEdgesPanGestureTo(vc: UIViewController) -> Void {
        if _edgesGesture == nil {
            _edgesGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgesAction(gesture:)))
            _edgesGesture.edges = .left
            vc.view.addGestureRecognizer(_edgesGesture)
        }
        _viewController = vc
    }
    
    @objc func edgesAction(gesture: UIScreenEdgePanGestureRecognizer) {
        var progress = gesture.translation(in: _viewController?.view).x / UIScreen.main.bounds.width
        progress = min(progress, 1)
        
        switch gesture.state {
        case .began:
            percentDriveTransition = UIPercentDrivenInteractiveTransition()
            _viewController?.navigationController?.popViewController(animated: true)
        case .changed:
            percentDriveTransition.update(progress)
        case .cancelled, .ended:
            if progress > 0.5 {
                percentDriveTransition.finish()
            } else {
                percentDriveTransition.cancel()
            }
        default:
            break
        }
    }
    
}
