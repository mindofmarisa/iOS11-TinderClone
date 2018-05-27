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
        if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedGenderSwitch.setOn(isInterestedInWomen, animated: false)
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
    
    func createWomen() {
        let imageUrls = ["https://www.redfin.com/blog/wp-content/uploads/sites/5/2007/10/cookie_kwan.png",
                         "https://www.factslides.com/imgs/marge.jpg", "https://vignette.wikia.nocookie.net/simpsons/images/6/6f/Titania_%28Official_Image%29.png/revision/latest?cb=20120330175037", "https://vignette.wikia.nocookie.net/simpsons/images/7/73/Mindy_Simmons_updated.png/revision/latest?cb=20140205200229", "https://openclipart.org/image/2400px/svg_to_png/228601/SimpsonsANAforopenclipart.png", "http://farm4.static.flickr.com/3362/3202331242_4e6b059332.jpg"]
        var counter = 0
        
        for imageUrl in imageUrls {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFile(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String(counter)
                    user.password = "Test@123"
                    user["isFemale"] = true
                    user["isInterestedInWomen"] = false
                    
                    user.signUpInBackground { (success, error) in
                        if success {
                            print("women created")
                        }
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
        PFUser.current()?["isInterestedInWomen"] = interestedGenderSwitch.isOn
        
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
                
                self.performSegue(withIdentifier: "profileToSwipeSegue", sender: nil)
            }
        })
    }
    


}
