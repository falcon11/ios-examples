//
//  ParentViewController.swift
//  Examples
//
//  Created by Ashoka on 05/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController, PresentedVCDelegate, UIViewControllerTransitioningDelegate {
    
    var presentAnimation = RotationPresentAnimation()
    var interactiveDismissAnimation = PanInteractiveTransition()
    var dismissAnimation = RotationDismissAnimation()
    
    func didPresented(vc: UIViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        print("present vc")
        let vc : SubViewController = segue.destination as! SubViewController
        vc.delegate = self
        vc.transitioningDelegate = self
        self.interactiveDismissAnimation.panToDismiss(vc: vc)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(presented, presenting, source)
        return presentAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return dismissAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("interaction controller for dismiss", interactiveDismissAnimation.isInteracting)
        return interactiveDismissAnimation.isInteracting ? interactiveDismissAnimation : nil
    }
    

}
