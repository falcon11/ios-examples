//
//  BadgeAnimationViewController.swift
//  Examples
//
//  Created by Ashoka on 15/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class BadgeAnimationViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let badge = BadgeView(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
        badge.containerView = self.containerView
        badge.badgeText = "99+"
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
