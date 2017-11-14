//
//  BounceViewVC.swift
//  Examples
//
//  Created by Ashoka on 14/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class BounceViewVC: UIViewController, CAAnimationDelegate, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var bounceView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    lazy var bounceLayer: CAShapeLayer! = {
        let bounceLayer = CAShapeLayer()
        self.bounceView.layer.addSublayer(bounceLayer)
        return bounceLayer
    }()
    var waterColor = UIColor(red:0.17, green:0.99, blue:1.00, alpha:1.00)
    let ballWidth: CGFloat! = 100.0
    lazy var ballView: UIView! = {
        let ballView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height/2, width: 100, height: 100))
        ballView.layer.cornerRadius = 50
        ballView.backgroundColor = UIColor.red
        self.view.addSubview(ballView)
        return ballView
    }()
    var offsetX: CGFloat! = 0

    @IBAction func dismissAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addGesture()
        self.configureBounceLayer()
        self.updateBounceLayerPathWith(offSetX: self.offsetX)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.bounceLayer.frame = self.bounceView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.alpha = 1
    }
    
    func configureBounceLayer() {
        self.bounceLayer.fillColor = waterColor.cgColor
    }
    
    func addGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(gesture:)))
        self.view.addGestureRecognizer(panGesture)
    }
    
    @objc func panGestureAction(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.bounceView)
        let offsetX = translation.x
        let offsetY = translation.y
        self.offsetX = offsetX
        var ballX = offsetX >= 0 ? (offsetX*0.4 - self.ballWidth) : (self.bounceView.bounds.width + offsetX * 0.4 )
        print("offset x", offsetX)
        
        switch gesture.state {
        case .changed:
            self.ballView.frame = CGRect(x: ballX, y: (self.bounceView.bounds.height-self.ballWidth)/2, width: self.ballWidth, height: self.ballWidth)
            self.updateBounceLayerPathWith(offSetX: offsetX)
            if abs(offsetX) > self.bounceView.bounds.width/2 {
                self.moveBallToCenter()
                self.view.removeGestureRecognizer(gesture)
                self.resetBounceLayer()
            }
        case .cancelled, .ended:
            if abs(offsetX) > self.bounceView.bounds.width/2 {
            } else {
                self.view.removeGestureRecognizer(gesture)
                self.resetBall()
                self.resetBounceLayer()
            }
            break
        default:
            break
        }
    }
    
    func moveBallToCenter() -> Void {
        let ballX = (self.bounceView.bounds.width - self.ballWidth)/2
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseIn, animations: {
            self.ballView.frame = CGRect(x: ballX, y: (self.bounceView.bounds.height-self.ballWidth)/2, width: self.ballWidth, height: self.ballWidth)
        }, completion: { (finished) in
            self.resetBall()
        })
    }
    
    func resetBall() {
        let ballX = offsetX >= 0 ? -100 : self.bounceView.bounds.width + 100
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.ballView.frame = CGRect(x: ballX, y: (self.bounceView.bounds.height-self.ballWidth)/2, width: self.ballWidth, height: self.ballWidth)
        }, completion: { (finished) in
            
        })
    }
    
    func resetBounceLayer() {
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.values = [
            self.getPathWith(offSetX: self.offsetX),
            self.getPathWith(offSetX: self.offsetX * 0.0),
            self.getPathWith(offSetX: self.offsetX * 0.6),
            self.getPathWith(offSetX: self.offsetX * 0.0),
            self.getPathWith(offSetX: self.offsetX * 0.25),
            self.getPathWith(offSetX: self.offsetX * 0.0),
            self.getPathWith(offSetX: self.offsetX * 0.05),
            self.getPathWith(offSetX: self.offsetX * 0.0),
        ]
        animation.duration = 0.5
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        animation.delegate = self
        self.bounceLayer.add(animation, forKey: "bounce")
        
    }
    
    func getPathWith(offSetX: CGFloat) -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounceView.bounds.width, y: 0))
        if offSetX < 0 {
            path.addQuadCurve(to: CGPoint(x: self.bounceView.bounds.width, y: self.bounceView.bounds.height), controlPoint: CGPoint(x: self.bounceView.bounds.width + offSetX, y: self.bounceView.bounds.height/2))
        } else {
            path.addLine(to: CGPoint(x: self.bounceView.bounds.width, y: self.bounceView.bounds.height))
        }
        path.addLine(to: CGPoint(x: 0, y: self.bounceView.bounds.height))
        if offSetX > 0 {
            path.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: CGPoint(x: offSetX, y: self.bounceView.bounds.height/2))
        } else {
            path.addLine(to: CGPoint.zero)
        }
        path.close()
        return path.cgPath
    }
    
    func updateBounceLayerPathWith(offSetX: CGFloat) {
        print("path offsetX", offSetX)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounceView.bounds.width, y: 0))
        if offSetX < 0 {
            path.addQuadCurve(to: CGPoint(x: self.bounceView.bounds.width, y: self.bounceView.bounds.height), controlPoint: CGPoint(x: self.bounceView.bounds.width + offSetX, y: self.bounceView.bounds.height/2))
        } else {
            path.addLine(to: CGPoint(x: self.bounceView.bounds.width, y: self.bounceView.bounds.height))
        }
        path.addLine(to: CGPoint(x: 0, y: self.bounceView.bounds.height))
        if offSetX > 0 {
            path.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: CGPoint(x: offSetX, y: self.bounceView.bounds.height/2))
        } else {
            path.addLine(to: CGPoint.zero)
        }
        path.close()
        self.bounceLayer.path = path.cgPath
        self.bounceLayer.layoutIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.updateBounceLayerPathWith(offSetX: 0)
        self.bounceLayer.removeAllAnimations()
        self.addGesture()
    }
    

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animationController = RotationDismissAnimation()
        return animationController
    }

}
