//
//  JellyAnimationVC.swift
//  Examples
//
//  Created by Ashoka on 14/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class JellyAnimationVC: UIViewController {
    
    @IBOutlet weak var assistantViewSide : UIView!
    @IBOutlet weak var assistantViewCenter : UIView!
    @IBOutlet weak var hitMeButton: UIButton!
    @IBOutlet weak var jellyView: UIView!
    var jellyLayer: CAShapeLayer!
    var waterColor = UIColor(red:0.17, green:0.99, blue:1.00, alpha:1.00)
    var isAtTop: Bool! = true
    let offSetY: CGFloat! = 0
    var displayLink: CADisplayLink!
    var animationCount: Int! = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addJellyLayer()
        self.hitMeButton.addTarget(self, action: #selector(hitMeAction), for: .touchUpInside)
        self.addDisplayLink()
        self.assistantViewCenter.isHidden = true
        self.assistantViewSide.isHidden = true
        self.jellyView.backgroundColor = waterColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func addJellyLayer() {
        self.jellyLayer = CAShapeLayer()
        self.jellyLayer.fillColor = self.waterColor.cgColor
        self.jellyView.layer.addSublayer(self.jellyLayer)
    }
    
    func addDisplayLink() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(updatePath(dis:)))
        self.displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        self.displayLink.isPaused = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.displayLink.isPaused = true
        self.displayLink.invalidate()
        self.displayLink = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func hitMeAction() {
        self.jellyView.backgroundColor = UIColor.clear
        self.displayLink.isPaused = false
        if isAtTop {
            self.animationPrepare()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                let sideFrame = self.assistantViewSide.frame
                self.assistantViewSide.frame = CGRect(x: 0, y: self.jellyView.bounds.height, width: sideFrame.width, height: sideFrame.height)
            }, completion: { (finished) in
                self.animationFinished()
            })
            self.animationPrepare()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveLinear, animations: {
                let centerFrame = self.assistantViewCenter.frame
                self.assistantViewCenter.frame = CGRect(x: (self.jellyView.bounds.width - centerFrame.width)/2, y: self.jellyView.bounds.height, width: centerFrame.width, height: centerFrame.height)
            }, completion: { (finished) in
                self.animationFinished()
            })
            
            self.isAtTop = false
        } else {
            self.animationPrepare()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveLinear, animations: {
                let sideFrame = self.assistantViewSide.frame
                self.assistantViewSide.frame = CGRect(x: 0, y: 0, width: sideFrame.width, height: sideFrame.height)
            }, completion: { (finished) in
                self.animationFinished()
            })
            self.animationPrepare()
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveLinear, animations: {
                let centerFrame = self.assistantViewCenter.frame
                self.assistantViewCenter.frame = CGRect(x: (self.jellyView.bounds.width - centerFrame.width)/2, y: 0, width: centerFrame.width, height: centerFrame.height)
            }, completion: { (finished) in
                self.animationFinished()
            })
            
            self.isAtTop = true
        }
    }
    
    func animationPrepare() {
        self.animationCount = self.animationCount + 1
    }
    
    func animationFinished() {
        self.animationCount  = self.animationCount - 1
        if self.animationCount == 0 {
            self.displayLink.isPaused = true
        }
    }
    
    @objc func updatePath(dis: CADisplayLink) {
        // we can get real time frame from layer.presentation
        let sideFrame = self.assistantViewSide.layer.presentation()!.frame
        let centerFrame = self.assistantViewCenter.layer.presentation()!.frame
        print(sideFrame.minY, centerFrame.minY)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: sideFrame.minY))
        path.addQuadCurve(to: CGPoint(x: self.jellyView.bounds.width, y: sideFrame.minY), controlPoint: CGPoint(x: centerFrame.midX, y: centerFrame.minY))
        path.addLine(to: CGPoint(x: self.jellyView.bounds.width, y: self.jellyView.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.jellyView.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: sideFrame.minY))
        path.close()
        self.jellyLayer.frame = self.jellyView.bounds
        self.jellyLayer.path = path.cgPath
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
