//
//  DynamicAnimationViewController.swift
//  Examples
//
//  Created by Ashoka on 20/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class DynamicAnimationViewController: UIViewController, CAAnimationDelegate {

    @IBOutlet weak var ballView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    lazy var animator: UIDynamicAnimator! = {
        var animator = UIDynamicAnimator.init(referenceView: self.view)
        return animator
    }()
    lazy var gravity: UIGravityBehavior! = {
        var gravity = UIGravityBehavior(items: [ballView])
        gravity.magnitude = 0.8
        return gravity
    }()
    
    lazy var collision: UICollisionBehavior! = {
        var collision = UICollisionBehavior(items: [ballView])
        return collision
    }()
    
    lazy var snap: UISnapBehavior! = {
        var snap = UISnapBehavior(item: ballView, snapTo: CGPoint(x: 160, y: 100))
        snap.damping = 0.8
        return snap
    }()
    
    lazy var shapeLayer: CAShapeLayer! = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.orange.cgColor
        return shapeLayer
    }()
    
    var originCenter: CGPoint! = CGPoint.zero
    
    let maxOffset: CGFloat! = 100
    
    var curOffset: CGFloat! = 0
    
    var displayLink: CADisplayLink!
    
    var animationCount: Int = 0 {
        didSet {
            if animationCount == 0 {
                displayLink?.isPaused = true
                startButton.isEnabled = true
            } else {
                startButton.isEnabled = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ballView.layer.cornerRadius = ballView.frame.width/2
        originCenter = ballView.center
        addAnimation()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func addAnimation() -> Void {
        startButton.isEnabled = false
        let displayLink = CADisplayLink(target: self, selector: #selector(displayLinkAction(displayLink:)))
        displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        self.displayLink = displayLink
        
        let item = UIDynamicItemBehavior(items:[ballView])
        item.elasticity = 0.5;
        item.density = 1;
        animator.addBehavior(item)
        
        animator.addBehavior(gravity)
        
        let path = UIBezierPath()
        path.move(to: scrollView.frame.origin)
        path.addQuadCurve(to: CGPoint(x: scrollView.frame.width, y: scrollView.frame.minY), controlPoint: CGPoint(x: scrollView.frame.width/2, y: scrollView.frame.minY))
        path.addLine(to: CGPoint(x: scrollView.frame.width, y: scrollView.frame.maxY))
        path.addLine(to: CGPoint(x: scrollView.frame.minX, y: scrollView.frame.maxY))
        path.addLine(to: scrollView.frame.origin)
        path.close()
        self.view.layer.insertSublayer(shapeLayer, below: scrollView.layer)
        shapeLayer.path = path.cgPath
        collision.addBoundary(withIdentifier: "collision" as NSString, for: path)
        animator.addBehavior(collision)
        snap.snapPoint = originCenter
    }
    
    func updatePath() -> Void {
        let path = UIBezierPath()
        path.move(to: scrollView.frame.origin)
        path.addQuadCurve(to: CGPoint(x: scrollView.frame.width, y: scrollView.frame.minY), controlPoint: CGPoint(x: scrollView.frame.width/2, y: scrollView.frame.minY+(curOffset >= -20 ? curOffset+120:0)))
        path.addLine(to: CGPoint(x: scrollView.frame.width, y: scrollView.frame.maxY))
        path.addLine(to: CGPoint(x: scrollView.frame.minX, y: scrollView.frame.maxY))
        path.addLine(to: scrollView.frame.origin)
        path.close()
        self.view.layer.insertSublayer(shapeLayer, below: scrollView.layer)
        shapeLayer.path = path.cgPath
        collision.removeBoundary(withIdentifier: "collision" as NSString)
        collision.addBoundary(withIdentifier: "collision" as NSString, for: path)
//        animator.addBehavior(gravity)
//        animator.addBehavior(collision)
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
    
    func resetView() -> Void {
        animator.removeAllBehaviors()
        animationCount += 1
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.ballView.center = self.originCenter
        }) { (finished) in
            self.animator.addBehavior(self.snap)
            self.animationCount -= 1
        }
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = 2 * CGFloat.pi
        rotationAnimation.duration = 0.1
        rotationAnimation.repeatCount = 5
        rotationAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        rotationAnimation.delegate = self
        ballView.layer.add(rotationAnimation, forKey: "rotation")
//        ballView.transform = CGAffineTransform(rotationAngle: .pi)
        
    }
    
    @objc func displayLinkAction(displayLink: CADisplayLink) {
        guard let ball = ballView.layer.presentation() else {
            return
        }
        curOffset = ball.frame.maxY - scrollView.frame.minY
        print(curOffset, ballView)
        if curOffset < maxOffset {
            updatePath()
        } else if curOffset >= maxOffset{
            curOffset = 0
            resetView()
        }
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        animator.removeAllBehaviors()
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        displayLink.isPaused = false
    }
    
    /// CAAnimationDelegate
    func animationDidStart(_ anim: CAAnimation) {
        animationCount += 1
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationCount -= 1
    }
    
    deinit {
        displayLink.invalidate()
        displayLink = nil
        animator.removeAllBehaviors()
    }
    
}
