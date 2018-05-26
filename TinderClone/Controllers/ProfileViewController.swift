//
//  ProfileViewController.swift
//  TinderClone
//
//  Created by Kenneth Nagata on 5/26/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    @IBOutlet weak var errorLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLabel.isHidden = true
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        if let isInterrestedInWomen = PFUser.current()?["isInterrestedInWomen"] as? Bool {
            interestedGenderSwitch.setOn(isInterrestedInWomen, animated: false)
        }
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground { (data, error) in
                if let imageData = data {
                    if let image = UIImage(data: imageData){
                        self.profileImageView.image = image
                    }
                }
            }
        }

    }

    @IBAction func updateProfileImageButtonPressed(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterrestedInWomen"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image{
            if let imageData = UIImagePNGRepresentation(image){
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData)
            }
        }
        
        PFUser.current()?.saveInBackground(block: { (success, error) in
            if error != nil {
                var errorMessage = "Update failed - Try again"
                if let newError = error as NSError? {
                    if let detailError = newError.userInfo["error"] as? String {
                        errorMessage = detailError
                    }
                }
                self.errorLabel.isHidden = false
                self.errorLabel.text = errorMessage
            } else {
                print("Update sucessful")
            }
        })
    }
    


}
