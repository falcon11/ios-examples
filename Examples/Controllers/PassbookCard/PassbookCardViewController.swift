//
//  PassbookCardViewController.swift
//  Examples
//
//  Created by Ashoka on 03/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class PassbookCardViewController: UIViewController {

    @IBOutlet weak var view0: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view4: UIView!
    var views = [UIView]()
    var viewsDict = Dictionary<String, Any>()
    var animationConstrains = [NSLayoutConstraint]()
    var willAnimate = false
    
    let maxHeight = UIScreen.main.bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        views.append(contentsOf: [view0, view1, view2, view3, view4])
        self.setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.layer.opacity = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.layer.opacity = 1
        }
    }
    
    func setupViews() -> Void {
        for view in views {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gesture:)))
            view.addGestureRecognizer(tap)
            let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(gesture:)))
            view.addGestureRecognizer(pan)
            guard let index = views.index(of: view) else {
                return
            }
            viewsDict["view\(index)"] = view
        }
        self.reset()
        self.view.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func tap(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        guard let index = views.index(of: view) else {
            return
        }
        if !self.willAnimate {
            animateViewAt(index: index)
        } else {
            self.reset()
        }
    }
    
    @objc func pan(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view else {
            return
        }
        let position = gesture.translation(in: view)
//        print("postioins", position.x, position.y)
        guard let index = self.views.index(of: view) else {
            return
        }
        if position.y < 0 && !self.willAnimate {
            self.view.removeConstraints(self.animationConstrains)
            let height = min(67 - position.y, self.maxHeight)
            let top = self.maxHeight - 5 * 67 + position.y
            var visualFormal = "V:|"
            for i in 0...(self.views.count - 1) {
                let key = "view\(i)"
                var value = "-0-[\(key)(67)]"
                if i == 0 {
                    value = "-(\(top))-[\(key)(67)]"
                }
                if i == index {
                    value = "-0-[\(key)(\(height))]"
                }
                if i == 0 && i == index {
                    value = "-(\(top))-[\(key)(\(height))]"
                }
                visualFormal.append(value)
            }
            self.animationConstrains = NSLayoutConstraint.constraints(withVisualFormat: visualFormal, options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: self.viewsDict)
            self.view.addConstraints(self.animationConstrains)
        }
        if position.y > 0 && self.willAnimate {
            self.view.removeConstraints(self.animationConstrains)
            let height = max((self.maxHeight - position.y), 67)
            var visualFormal = "V:|"
            for i in 0...(self.views.count - 1) {
                let key = "view\(i)"
                var value = "-(0)-[\(key)(67)]"
                if i == 0 {
                    value = "-(\(-1 * CGFloat(index) * 67 + position.y))-[\(key)(67)]"
                }
                if i == index {
                    value = "-0-[\(key)(\(height))]"
                }
                if i == 0 && i == index {
                    value = "-(\(-1 * CGFloat(index) * 67 + position.y))-[\(key)(\(height))]"
                }
                visualFormal.append(value)
            }
            self.animationConstrains = NSLayoutConstraint.constraints(withVisualFormat: visualFormal, options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: self.viewsDict)
            self.view.addConstraints(self.animationConstrains)
        }
        
        if gesture.state == .ended {
            if willAnimate {
                if position.y >= 40 { self.reset() }
                else { self.animateViewAt(index: index) }
            } else {
                if position.y <= -40 { self.animateViewAt(index: index) }
                else { self.reset() }
            }
        }
    }
    
    func reset() {
        self.willAnimate = false
        UIView.animate(withDuration: 0.3) {
            self.view.removeConstraints(self.animationConstrains)
            var visualFormal = "V:"
            for i in 0...(self.views.count - 1) {
                let value = "[view\(i)(67)]-0-"
                visualFormal.append(value)
            }
            visualFormal.append("|")
            self.animationConstrains = NSLayoutConstraint.constraints(withVisualFormat: visualFormal, options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: self.viewsDict)
            self.view.addConstraints(self.animationConstrains)
            self.view.layoutIfNeeded()
        }
    }
    
    func animateViewAt(index: Int) {
        self.willAnimate = true
        UIView.animate(withDuration: 0.3, animations: {
            self.view.removeConstraints(self.animationConstrains)
            var visualFormal = "V:|"
            for i in 0...(self.views.count - 1) {
                let key = "view\(i)"
                var value = "-0-[\(key)(67)]"
                if i == 0 {
                    value = "-(-\(index*67))-[\(key)(67)]"
                }
                if i == index {
                    value = "-0-[\(key)(\(self.maxHeight))]"
                }
                visualFormal.append(value)
            }
            self.animationConstrains = NSLayoutConstraint.constraints(withVisualFormat: visualFormal, options: NSLayoutFormatOptions.init(rawValue: 0), metrics: nil, views: self.viewsDict)
            self.view.addConstraints(self.animationConstrains)
            self.view.layoutIfNeeded()
        })
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
