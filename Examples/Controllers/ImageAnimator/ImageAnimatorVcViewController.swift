//
//  ImageAnimatorVcViewController.swift
//  Examples
//
//  Created by Ashoka on 02/11/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit

class ImageAnimatorVcViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var button: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    func setupViews() -> Void {
        button?.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
        button?.setTitle("stop", for: .selected)
        button?.setTitle("start", for: .normal)
    }
    
    @objc func buttonAction(button: UIButton) {
        if button.isSelected {
            self.stopAnimator()
            button.isSelected = false
        } else {
            self.startAnimator()
            button.isSelected = true
        }
    }
    
    func startAnimator() -> Void {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromLeft, .curveEaseInOut, .transitionCrossDissolve], animations: {
            self.imageView?.frame = CGRect.init(x: (self.view.bounds.size.width - self.imageView.bounds.width) / 2.0,
                                               y: self.imageView.bounds.height,
                                               width: self.imageView.bounds.width,
                                               height: self.imageView.bounds.height)
        }) { (finished) in
            var images = [UIImage]()
            for idx in 1 ... 8 {
                if let aImage = UIImage(named: "icon_shake_animation_\(idx)") {
                    images.append(aImage)
                }
            }
            self.imageView?.animationDuration = 0.2
            self.imageView?.animationImages = images
            self.imageView?.animationRepeatCount = 0
            self.imageView?.startAnimating()
        }
    }
    
    func stopAnimator() -> Void {
        self.imageView?.stopAnimating()
        let duration = 0.5
        var images = [UIImage]()
        for idx in 1 ... 5 {
            if let aImage = UIImage(named: "icon_pull_animation_\((5 - idx + 1))") {
                images.append(aImage)
            }
        }
        self.imageView.animationDuration = duration
        self.imageView.animationRepeatCount = 1
        self.imageView.animationImages = images
        self.imageView.image = UIImage.init(named: "icon_pull_animation_1")
        self.imageView.startAnimating()
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            self.imageView.center = self.view.center
        }) { (finished) in
            
        }
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
