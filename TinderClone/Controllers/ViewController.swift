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
    
    @IBOutlet weak var matchImageView: UIImageView!
    
    var displayUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        matchImageView.addGestureRecognizer(gesture)
        
        updateImage()
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error) in
            if let point = geoPoint {
                PFUser.current()?["location"] = point
                PFUser.current()?.saveInBackground()
            }
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: UIBarButtonItem) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer){
        let labelPoint = gestureRecognizer.translation(in: view)
        matchImageView.center = CGPoint(x: view.bounds.width/2 + labelPoint.x, y: view.bounds.height/2 + labelPoint.y)
        
        let xFromCenter = view.bounds.width/2 - matchImageView.center.x
        let scale =  min(100/abs(xFromCenter), 1)
        
        var rotation = CGAffineTransform(rotationAngle: xFromCenter/100)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        
        matchImageView.transform = scaledAndRotated
        
        if gestureRecognizer.state == .ended {
            
            var acceptedOrRejected = ""
            
            if matchImageView.center.x < (view.bounds.width / 2 - 100) {
                print("not interested")
                acceptedOrRejected = "rejected"
            }
            
            if matchImageView.center.x > (view.bounds.width / 2 + 100) {
                print("interested")
                acceptedOrRejected = "accepted"
            }
            
            if acceptedOrRejected != "" && displayUserId != "" {
                PFUser.current()?.addUniqueObject(displayUserId, forKey: acceptedOrRejected)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
            
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            matchImageView.transform = scaledAndRotated
            matchImageView.center = CGPoint(x: view.bounds.width/2, y: view.bounds.height/2)
        }
    }
    
    func updateImage() {
        var ignoredUsers : [String] = []

        if let query = PFUser.query(){
            
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"]{
                query.whereKey("isFemale", equalTo: isInterestedInWomen)
            }
            
            if let isFemale = PFUser.current()?["isFemale"]{
                query.whereKey("isInterestedInWomen", equalTo: isFemale)
            }

            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                ignoredUsers += acceptedUsers
            }
            
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                ignoredUsers += rejectedUsers
            }
            
            query.whereKey("objectId", notContainedIn: ignoredUsers)
            
            // select users within 10 miles
            if let geoPoint = PFUser.current()?["location"] as? PFGeoPoint{
                query.whereKey("location", withinGeoBoxFromSouthwest: PFGeoPoint(latitude: geoPoint.latitude - 1, longitude: geoPoint.longitude - 1), toNortheast: PFGeoPoint(latitude: geoPoint.latitude + 1, longitude: geoPoint.longitude + 1))
            }
            
            query.limit = 1
            
            query.findObjectsInBackground { (objects, error) in
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        self.matchImageView.image = UIImage(data: imageData)
                                        if let objectID = object.objectId{
                                            self.displayUserId = objectID
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
}

