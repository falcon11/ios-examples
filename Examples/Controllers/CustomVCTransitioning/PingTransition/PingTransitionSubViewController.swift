//
//  PingTransitionSubViewController.swift
//  Examples
//
//  Created by Ashoka on 09/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class PingTransitionSubViewController: UIViewController, PingTransitionProtocol {
    var isInteract: Bool = false
    var interactiveTransition: UIPercentDrivenInteractiveTransition? = UIPercentDrivenInteractiveTransition()
    
    @IBOutlet weak var button : UIButton!
    @IBOutlet weak var label : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.button.layer.cornerRadius = self.button.bounds.width/2
        self.button.addTarget(self, action: #selector(back), for: .touchUpInside)
        
        guard let navDelegate = self.navigationController?.delegate as? PingTransitionUINavigationVCDelegate else {
            return
        }
        navDelegate.addPopGestureTo(vc: self)
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
        
        /// add mask layer, only view covered by the mask layer can be seen
//        let layer = CAShapeLayer()
//        layer.frame = CGRect(x: 100, y: 200, width: 60, height: 60)
//        let path = UIBezierPath(ovalIn: CGRect(x: 100, y: 200, width: 60, height: 60))
//        layer.path = path.cgPath
//        self.view.layer.mask = label.layer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
