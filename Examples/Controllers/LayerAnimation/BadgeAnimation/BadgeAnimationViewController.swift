//
//  BadgeAnimationViewController.swift
//  Examples
//
//  Created by Ashoka on 15/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class BadgeAnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let badge = BadgeView(frame: CGRect(x: 100, y: 200, width: 30, height: 30))
        badge.containerView = self.view
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
