//
//  BadgeView.swift
//  Examples
//
//  Created by Ashoka on 15/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class BadgeView: UIView {
    
    var containerView: UIView? {
        didSet {
            containerView?.addSubview(self)
            setup()
        }
    }
    var badgeLabel: UILabel! = UILabel()
    var badgeText: String! = "99+" {
        didSet {
            self.badgeLabel?.text = badgeText
            self.badgeLabel?.sizeToFit()
            self.badgeLabel.textColor = self.textColor
            self.badgeLabel.center = CGPoint(x:frontView.bounds.midX, y: frontView.bounds.midY)
        }
    }
    var textColor: UIColor! = UIColor.white {
        didSet {
            self.badgeLabel.textColor = textColor
        }
    }
    var viscosity: CGFloat! = 20
    var badgeColor: UIColor! = UIColor.red
    var badgePosition: CGPoint? {
        didSet {
            x1 = badgePosition?.x
            y1 = badgePosition?.y
            x2 = x1
            y2 = y1
        }
    }
    var backView: UIView! = UIView()
    var frontView: UIView! = UIView()
    lazy var shapeLayer: CAShapeLayer? = {
        let layer = CAShapeLayer()
        layer.fillColor = badgeColor.cgColor
        return layer
    }()
    
    var badgeWidth: CGFloat! = 30
    
    private var x1: CGFloat! = 15
    private var x2: CGFloat! = 15
    private var y1: CGFloat! = 15
    private var y2: CGFloat! = 15
    private var d: CGFloat! {
        get {
            return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2))
        }
    }
    private var cosBeth: CGFloat! {
        get {
            return (y2 - y1)/d
        }
    }
    
    private var sinBeth: CGFloat! {
        get {
            return (x2 - x1)/d
        }
    }
    
    private var r1: CGFloat! {
        get {
            let r = badgeWidth / 2 - d / viscosity
            return r >= 6 ? r : 6
        }
    }
    
    private var r2: CGFloat! {
        get {
            return badgeWidth / 2
        }
    }
    
    private var pointA: CGPoint! {
        get {
            return CGPoint(x: x1 - r1 * cosBeth, y: y1 + r1 * sinBeth)
        }
    }
    
    private var pointB: CGPoint! {
        get {
            return CGPoint(x: x1 + r1 * cosBeth, y: y1 - r1 * sinBeth)
        }
    }
    
    private var pointC: CGPoint! {
        get {
            return CGPoint(x: x2 + r2 * cosBeth, y: y2 - r2 * sinBeth)
        }
    }
    
    private var pointD: CGPoint! {
        get {
            return CGPoint(x: x2 - r2 * cosBeth, y: y2 + r2 * sinBeth)
        }
    }
    
    private var pointO: CGPoint! {
        get {
            return CGPoint(x: pointA.x + d / 2 * sinBeth, y: pointA.y + d / 2 * cosBeth)
        }
    }

    private var pointP: CGPoint! {
        get {
            return CGPoint(x: pointB.x + d / 2 * sinBeth, y: pointB.y + d / 2 * cosBeth
            )
        }
    }
    
    private var centerBack: CGPoint! {
        get {
            return CGPoint(x: x1, y: y1)
        }
    }
    
    private var centerFront: CGPoint! {
        get {
            return CGPoint(x: x2, y: y2)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.badgePosition = CGPoint(x: frame.midX, y: frame.midY)
        x1 = frame.midX
        x2 = x1 //+ 100
        y1 = frame.midY
        y2 = y1 //+ 100
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    func setup() -> Void {
        self.backgroundColor = UIColor.clear
        backView.backgroundColor = badgeColor
        frontView.backgroundColor = badgeColor
        self.badgeLabel?.text = badgeText
        self.badgeLabel.sizeToFit()
        frontView.addSubview(self.badgeLabel)
        guard let shapeLayer = self.shapeLayer else {
            return
        }
        guard let container = self.containerView else {
            return
        }
        shapeLayer.frame = container.bounds
        self.containerView?.layer.addSublayer(shapeLayer)
        self.containerView?.addSubview(backView)
        self.containerView?.addSubview(frontView)
        updatePath()
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandle(gesture:)))
        frontView.addGestureRecognizer(gesture)
    }
    
    @objc func panGestureHandle(gesture: UIPanGestureRecognizer) {
        let position = gesture.location(in: self.containerView) //gesture.translation(in: frontView)
        x2 = position.x
        y2 = position.y
        switch gesture.state {
        case .changed:
            updatePath()
        case .cancelled, .ended, .failed:
            if r1 > 6.0 {
                x2 = x1
                y2 = y1
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                    self.updatePath()
                }, completion: { (finished) in
                    
                })
            } else {
                frontView.boom()
            }
        default:
            break
        }
    }
    
    func updatePath() -> Void {
        
        backView.bounds = CGRect(x: 0, y: 0, width: r1 * 2, height: r1 * 2)
        backView.center = centerBack
        frontView.bounds = CGRect(x: 0, y: 0, width: r2 * 2, height: r2 * 2)
        frontView.center = centerFront
        backView.layer.cornerRadius = r1
        frontView.layer.cornerRadius = r2
        self.badgeLabel.center = CGPoint(x:frontView.bounds.midX, y: frontView.bounds.midY)
        
        let path = UIBezierPath()
        if d > 0 {
            path.move(to: pointA)
            path.addQuadCurve(to: pointD, controlPoint: pointO)
            path.addLine(to: pointC)
            path.addQuadCurve(to: pointB, controlPoint: pointP)
            path.addLine(to: pointA)
            backView.isHidden = false
            frontView.isHidden = false
        } else {
            path.move(to: CGPoint(x: x1 - badgeWidth/2, y: y1))
            path.addArc(withCenter: centerBack, radius: r1, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            backView.isHidden = true
        }
        path.close()
        if r1 <= 6.0 {
            shapeLayer?.path = nil
            backView.isHidden = true
        } else {
            backView.isHidden = false
            shapeLayer?.path = path.cgPath
        }
    }

}

private extension UIView {
    func boom() -> Void {
        self.isHidden = true
        var images: [UIImage] = Array()
        for i in 1...5 {
            let image: UIImage! = UIImage(named: "unreadBomb_\(i)")
            images.append(image)
        }
        let imageView = UIImageView()
        imageView.frame = self.frame
        self.superview?.addSubview(imageView)
        imageView.animationImages = images
        imageView.animationDuration = 0.5
        imageView.animationRepeatCount = 1
        imageView.startAnimating()
        imageView.addImageAnimationObserver()
    }
}

private extension UIImageView {
    func addImageAnimationObserver() -> Void {
        let dis = CADisplayLink(target: self, selector: #selector(displayLinkHandler(displayLink:)))
        dis.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
    }
    
    @objc func displayLinkHandler(displayLink: CADisplayLink) -> Void {
        print("self", self, displayLink)
        if !self.isAnimating {
            self.removeFromSuperview()
            displayLink.invalidate()
        }
    }
}
