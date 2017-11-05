//
//  SubViewController.swift
//  Examples
//
//  Created by Ashoka on 05/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class SubViewController: UIViewController {
    
    weak var delegate : PresentedVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissAction(_ sender: UIButton) {
        delegate?.didPresented(vc: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        print("present vc")
//    }
 

}
