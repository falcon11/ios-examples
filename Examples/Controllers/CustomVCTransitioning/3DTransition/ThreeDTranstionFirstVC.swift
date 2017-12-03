//
//  3DTranstionFirstVC.swift
//  Examples
//
//  Created by Ashoka on 03/12/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ThreeDTranstionFirstVC: UIViewController, UINavigationControllerDelegate {
    
    let panToPop = PanToPop()
    var popInteractiveTransition: ThreeDPopInteractiveTransition!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.cyan
        panToPop.addEdgesPanGestureTo(vc: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.alpha = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.alpha = 1
        }
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
        let vc = segue.destination
        popInteractiveTransition = ThreeDPopInteractiveTransition()
        popInteractiveTransition.addPopGestureTo(vc: vc)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC.isKind(of: ThreeDTranstionFirstVC.self) {
            let transition = ThreeDPushTransition()
            return transition
        }
        else if fromVC.isKind(of: ThreeDTransitionSecondVC.self) {
            let transition = ThreeDPopTransition()
            return transition
        }
        else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: ThreeDPopTransition.self) && popInteractiveTransition.isInteracting {
            return popInteractiveTransition
        } else {
            return nil
        }
    }

}
