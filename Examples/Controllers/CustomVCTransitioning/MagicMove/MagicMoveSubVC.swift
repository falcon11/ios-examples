//
//  MagicMoveSubVC.swift
//  Examples
//
//  Created by Ashoka on 07/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class MagicMoveSubVC: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var imageView : UIImageView!
    var percentDrivenTransition : UIPercentDrivenInteractiveTransition!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        self.addGesture()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    
    func addGesture() -> Void {
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgeGestureAction(gesture:)))
        edgePanGesture.edges = .left
        self.view.addGestureRecognizer(edgePanGesture)
    }
    
    @objc func edgeGestureAction(gesture: UIScreenEdgePanGestureRecognizer) -> Void {
        let offsetX = gesture.translation(in: self.view).x
        var progress = offsetX/UIScreen.main.bounds.width
        progress = min(progress, 1)
        
        switch gesture.state {
        case .began:
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            self.navigationController?.popViewController(animated: true)
        case .changed:
            percentDrivenTransition.update(progress)
        case .cancelled, .ended:
            if progress >= 0.5 {
                percentDrivenTransition.finish()
            } else {
                percentDrivenTransition.cancel()
            }
            percentDrivenTransition = nil
        default:
            break
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: MagicMoveInverseTransition.self) {
            return percentDrivenTransition
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if fromVC.isKind(of: MagicMoveSubVC.self) {
            let inverseTransition = MagicMoveInverseTransition()
            return inverseTransition
        } else {
            return nil
        }
    }

}
