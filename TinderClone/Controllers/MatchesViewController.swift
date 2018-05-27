//
//  MatchesViewController.swift
//  TinderClone
//
//  Created by Kenneth Nagata on 5/27/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import Parse

class MatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
   
    var userImages: [UIImage] = []
    var UserIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            
            if let accepted = PFUser.current()?["accepted"] as? [String] {
                query.whereKey("objectId", containedIn: accepted)
                
                query.findObjectsInBackground { (objects, error) in
                    if let users = objects {
                        for user in users {
                            if let theUser = user as? PFUser {
                                if let imageFile = theUser["photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if let imageData = data {
                                            if let image = UIImage(data: imageData) {                                            self.userImages.append(image)
                                                if let objectId = theUser.objectId {
                                                    self.UserIds.append(objectId)
                                                    self.tableView.reloadData()
                                                }
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
        
        print(userImages.count)
        print(UserIds.count)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchTableViewCell {
            cell.messageLabel.text = "No messages yet."
            cell.profileImageView.image = userImages[indexPath.row]
            return cell
        }   
        return UITableViewCell()
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
        print("button pressed")
    }
    

    
}
