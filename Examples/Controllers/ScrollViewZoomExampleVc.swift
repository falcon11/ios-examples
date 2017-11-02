//
//  ScrollViewZoomExample.swift
//  Examples
//
//  Created by Ashoka on 30/10/2017.
//  Copyright © 2017 Ashoka. All rights reserved.
//

import UIKit
import AVFoundation

class ScrollViewZoomExampleVc: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var imageView: UIImageView!;
    @IBOutlet weak var scrollView: UIScrollView!;
    var imageSrc = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509939419&di=9bc79490f008800a7641dccc473f4f02&imgtype=jpg&er=1&src=http%3A%2F%2Fimages.freeimages.com%2Fimages%2Fpremium%2Fpreviews%2F4739%2F47397574-cute-little-witch-s.jpg"//"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1509339952363&di=aaed258ddf177e11f07a3ff89e6530f9&imgtype=0&src=http%3A%2F%2Fwww.jianjiaobuluo.com%2FUploads%2Feditor%2F20160328%2F1459157640100345.jpg";
    var doubleTapRecognizer = UITapGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setupViews()
        self.loadImage()
        setupGesturesRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.layer.opacity = 0
        }
    }
    
    func setupViews() -> Void {
//        self.navigationController?.navigationBar.isHidden = true
        scrollView.decelerationRate = UIScrollViewDecelerationRateFast
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.contentOffset = CGPoint.zero
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
    }
    
    func setupGesturesRecognizer() {
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.addTarget(self, action: #selector(scrollViewDidDoubleTap(_:)))
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func loadImage() -> Void {
        DispatchQueue(label: "imageloader").async {
            do {
                let data = try Data(contentsOf: URL(string: self.imageSrc)!);
                let image = UIImage(data: data);
                DispatchQueue.main.async {
                    self.imageView.image = image;
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                }
            } catch {
                
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.frame = view.bounds
        if let size = imageView.image?.size, size != CGSize.zero {
            let scrollViewSize = scrollView.bounds.size
            let scale = size.width/size.height > scrollViewSize.width/scrollViewSize.height ? size.width/scrollViewSize.width : size.height/scrollViewSize.height
            imageView.bounds.size = CGSize(width: size.width/scale, height: size.height/scale)
            scrollView.contentSize = imageView.bounds.size
            imageView.center = CGPoint.init(x: scrollViewSize.width/2, y: scrollViewSize.height/2)
        }
    }
    
    // MARK: - ScrollViewDelegate
    
    @objc func scrollViewDidDoubleTap(_ recognizer: UITapGestureRecognizer) {
        let touchPoint = recognizer.location(ofTouch: 0, in: imageView)
        let aspectFillScale = aspectFillZoomScale(forBoundingSize: scrollView.bounds.size, contentSize: imageView.bounds.size)
        
        if (scrollView.zoomScale == 1.0 || scrollView.zoomScale > aspectFillScale) {
            
            let zoomRectangle = zoomRect(ForScrollView: scrollView, scale: aspectFillScale, center: touchPoint)
            print("...zoomRect", zoomRectangle)
            
            UIView.animate(withDuration: 0.55, animations: { [weak self] in
                
                self?.scrollView.zoom(to: zoomRectangle, animated: false)
            })
        }
        else  {
            UIView.animate(withDuration: 0.55, animations: {  [weak self] in
                
                self?.scrollView.setZoomScale(1.0, animated: false)
            })
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("contentsize", scrollView.contentSize);
        imageView.center = self.contentCenter(forBoundingSize: scrollView.bounds.size, contentSize: scrollView.contentSize)
    }
    
    func contentCenter(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGPoint {
        
        /// When the zoom scale changes i.e. the image is zoomed in or out, the hypothetical center
        /// of content view changes too. But the default Apple implementation is keeping the last center
        /// value which doesn't make much sense. If the image ratio is not matching the screen
        /// ratio, there will be some empty space horizontally or vertically. This needs to be calculated
        /// so that we can get the correct new center value. When these are added, edges of contentView
        /// are aligned in realtime and always aligned with corners of scrollView.
        
        let horizontalOffset = (boundingSize.width > contentSize.width) ? ((boundingSize.width - contentSize.width) * 0.5): 0.0
        let verticalOffset   = (boundingSize.height > contentSize.height) ? ((boundingSize.height - contentSize.height) * 0.5): 0.0
        
        return CGPoint(x: contentSize.width * 0.5 + horizontalOffset, y: contentSize.height * 0.5 + verticalOffset)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.2) {
            self.navigationController?.navigationBar.layer.opacity = 1
        }
    }

//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        DispatchQueue.main.async {
//            print(self.navigationController)
//            self.navigationController?.navigationBar.isHidden = false
//        }
//    }
    
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

func aspectFitContentSize(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGSize {
    
    return AVMakeRect(aspectRatio: contentSize, insideRect: CGRect(origin: CGPoint.zero, size: boundingSize)).size
}

func aspectFillZoomScale(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGFloat {
    
    let aspectFitSize = aspectFitContentSize(forBoundingSize: boundingSize, contentSize: contentSize)
    return (floor(boundingSize.width) == floor(aspectFitSize.width)) ? (boundingSize.height / aspectFitSize.height): (boundingSize.width / aspectFitSize.width)
}

func zoomRect(ForScrollView scrollView: UIScrollView, scale: CGFloat, center: CGPoint) -> CGRect {
    
    let width = scrollView.frame.size.width  / scale
    let height = scrollView.frame.size.height / scale
    let originX = center.x - (width / 2.0)
    let originY = center.y - (height / 2.0)
    
    return CGRect(x: originX, y: originY, width: width, height: height)
}
