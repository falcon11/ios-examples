//
//  PingTransitionParentViewController.swift
//  Examples
//
//  Created by Ashoka on 09/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class PingTransitionParentViewController: UIViewController, UINavigationControllerDelegate, PingTransitionProtocol {
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition? = UIPercentDrivenInteractiveTransition()
    
    var isInteract: Bool = false
    var navDelegate = PingTransitionUINavigationVCDelegate()
    
//    var pingTransition = PingTransitionAnimation()
    @IBOutlet weak var button : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.button.layer.cornerRadius = self.button.bounds.width/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self.navDelegate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        return nil
//    }
//
//    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        if operation == .push && fromVC == self && toVC.isKind(of: PingTransitionSubViewController.self) {
//            let pingTransition = PingTransitionAnimation()
//            pingTransition.isPush = true
//            return pingTransition
//        } else if operation == .pop && toVC == self {
//            let pingTransition = PingTransitionAnimation()
//            pingTransition.isPush = false
//            return pingTransition
//        }
//        return nil
//    }

}
