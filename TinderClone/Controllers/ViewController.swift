//
//  ViewController.swift
//  TinderClone
//
//  Created by Kenneth Nagata on 5/26/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var swipeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        swipeLabel.addGestureRecognizer(gesture)
    }


    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        let labelPoint = gestureRecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width/2 + labelPoint.x, y: view.bounds.height/2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width/2 - swipeLabel.center.x
        
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/100)
        
        let scale =  min(100/abs(xFromCenter), 1)
        
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        swipeLabel.transform = scaledAndRotated
        
        if gestureRecognizer.state == .ended {
            if swipeLabel.center.x < (view.bounds.width / 2 - 100) {
                print("not interested")
            }
            
            if swipeLabel.center.x > (view.bounds.width / 2 + 100) {
                print("interested")
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            swipeLabel.transform = scaledAndRotated
            swipeLabel.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        }
    }


}

