//
//  ViewController.swift
//  Examples
//
//  Created by Ashoka on 30/10/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        YYViewHierarchy3D.show();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

