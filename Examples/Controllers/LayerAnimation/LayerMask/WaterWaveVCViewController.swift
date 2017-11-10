//
//  WaterWaveVCViewController.swift
//  Examples
//
//  Created by Ashoka on 10/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class WaterWaveVCViewController: UIViewController {
    
    @IBOutlet weak var waterView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var whiteLabel: UILabel!
    lazy var waveLayer: CAShapeLayer! = {
        let waveLayer = CAShapeLayer()
        return waveLayer
    }()
    var wavePath: UIBezierPath!
    var a: CGFloat = 1.5
    var b: CGFloat = 0
    var pluse: Bool = false
    var waterColor = UIColor(red:0.17, green:0.99, blue:1.00, alpha:1.00)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.waterView.layer.backgroundColor = UIColor.clear.cgColor
        self.waterView.backgroundColor = UIColor.clear
        self.waveLayer.fillColor = waterColor.cgColor
        self.waterView.layer.addSublayer(self.waveLayer)
        
        Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(animateWave), userInfo: nil, repeats: true)
    }
    
    @objc func animateWave() {
        if self.pluse {
            a += 0.01
        } else {
            a -= 0.01
        }
        if a <= 1 { self.pluse = true }
        if a >= 1.5 { self.pluse = false }
        b += 0.1
        self.updateWavePath()
    }
    
    func updateWaterView() {
        
        self.waveLayer.frame = self.waterView.bounds
        self.waveLayer.path = self.wavePath.cgPath
        
        let maskLayer = CAShapeLayer()
        let rect = whiteLabel.convert(waterView.frame, from: self.view)
        maskLayer.frame = rect
        maskLayer.path = self.wavePath.cgPath
        whiteLabel.layer.mask = maskLayer
    }
    
    func updateWavePath() -> Void {
        
        let bp = UIBezierPath()
        bp.move(to: self.waterView.frame.origin)
        for x in 0...Int(self.waterView.bounds.width) {
            let y = a * sin(CGFloat(x) / 180 * CGFloat.pi + 4 * b / CGFloat.pi) * 8
            bp.addLine(to: CGPoint(x: CGFloat(x), y: y))
        }
        bp.addLine(to: CGPoint(x: self.waterView.bounds.width, y: self.waterView.bounds.height))
        bp.addLine(to: CGPoint(x: 0, y: self.waterView.bounds.height))
        bp.addLine(to: self.waterView.frame.origin)
        bp.close()
        
        self.wavePath = bp
        self.updateWaterView()
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
