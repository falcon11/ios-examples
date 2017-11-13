//
//  CustomPresentation.swift
//  Examples
//
//  Created by Ashoka on 13/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class CustomPresentation: UIPresentationController {
    
    let offsetY: CGFloat! = 320.0
    weak var transitionCoordinator: UIViewControllerTransitionCoordinator!
    
    lazy var bgView: UIView! = {
        let bgView = UIView(frame: UIScreen.main.bounds)
        let blurView = UIVisualEffectView.init(effect: UIBlurEffect.init(style: .dark))
        blurView.frame = self.containerView!.bounds
        bgView.addSubview(blurView)
        return bgView
    }()
    
    override func presentationTransitionWillBegin() {
        print("custom presentation", self.presentingViewController, self.presentedViewController)
        print("presentation container", self.containerView)
        self.containerView?.addSubview(self.presentingViewController.view)
        self.containerView?.addSubview(self.bgView)
        self.containerView?.addSubview(presentedViewController.view)
        
        self.bgView.alpha = 0
        self.transitionCoordinator = self.presentingViewController.transitionCoordinator
        self.transitionCoordinator.animate(alongsideTransition: { (context) in
            self.bgView.alpha = 0.7
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: nil)
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if !completed {
            self.bgView .removeFromSuperview()
            self.resetPresentingView()
        }
    }
    
    override func dismissalTransitionWillBegin() {
        print("presenting Vc", self.presentingViewController)
        self.transitionCoordinator = self.presentingViewController.transitionCoordinator
        self.transitionCoordinator.animate(alongsideTransition: { (context) in
            self.bgView.alpha = 0
            self.resetPresentingView()
        }, completion: nil)
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        if completed {
            self.bgView.removeFromSuperview()
            
            // if not add this line self.presentingViewController will be released, what you will see is only a black window
            UIApplication.shared.keyWindow?.addSubview(self.presentingViewController.view)
        }
    }
    
    override var presentedView: UIView? {
        let view = self.presentedViewController.view
        view?.layer.cornerRadius = 12
        return view
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let frame = self.containerView!.bounds
        let newFrame = CGRect(x: 0, y: self.offsetY, width: frame.width, height: frame.height - self.offsetY)
        return newFrame
    }
    
    func resetPresentingView() {
        self.presentingViewController.view.transform = CGAffineTransform.identity
    }
    
    
}

