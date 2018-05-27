//
//  LogInViewController.swift
//  TinderClone
//
//  Created by Kenneth Nagata on 5/26/18.
//  Copyright © 2018 Kenneth Nagata. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTetField: UITextField!
    @IBOutlet weak var logInSignUpButton: UIButton!
    @IBOutlet weak var changeLogInSignUpButton: UIButton!
    @IBOutlet weak var errorLAbel: UILabel!
    
    var signUpMode = false
  
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLAbel.isHidden = true

        // Do any additional setup after loading the view.
    }

    @IBAction func logInSignUpButtonPressed(_ sender: UIButton) {
        
        if signUpMode {
            let user = PFUser()
            
            user.username = usernameTextField.text
            user.password = passwordTetField.text
            
            user.signUpInBackground { (success, error) in
                
                if error != nil {
                    // sign up not successful, put code here
                    var errorMessage = "Sign up failed - Try again"
                    if let newError = error as NSError? {
                        if let detailError = newError.userInfo["error"] as? String {
                            errorMessage = detailError
                        }
                    }
                    self.errorLAbel.isHidden = false
                    self.errorLAbel.text = errorMessage
                } else {
                    // sign up successful, put code here
                    print("sign up sucessful")
                    self.performSegue(withIdentifier: "updateSegue", sender: nil)
                }
            }
        } else {         
            if let username = usernameTextField.text,
                let password = passwordTetField.text{
                    PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
                        if error != nil {
                            // Log in not succesful, put code here
                            var errorMessage = "Log in failed - Try again"
                            if let newError = error as NSError? {
                                if let detailError = newError.userInfo["error"] as? String {
                                    errorMessage = detailError
                                }
                            }
                            self.errorLAbel.isHidden = false
                            self.errorLAbel.text = errorMessage
                        } else {
                            // Log in successful, put code here
                            print("Log in sucessful")
                            if user?["isFemale"] != nil {
                                self.performSegue(withIdentifier: "loginToSwipeSegue", sender: nil)
                            } else {
                                self.performSegue(withIdentifier: "updateSegue", sender: nil)
                            }
                        }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil {
            
            if PFUser.current()?["isFemale"] != nil {
                performSegue(withIdentifier: "loginToSwipeSegue", sender: nil)
            } else {
                performSegue(withIdentifier: "updateSegue", sender: nil)
            }
        }
    }
    
    @IBAction func changeLogInSignUpButtonPressed(_ sender: UIButton) {
        if signUpMode {
            logInSignUpButton.setTitle("Log In", for: .normal)
            changeLogInSignUpButton.setTitle("Sign Up", for: .normal)
            signUpMode = false
        } else {
            logInSignUpButton.setTitle("Sign Up", for: .normal)
            changeLogInSignUpButton.setTitle("Log In", for: .normal)
            signUpMode = true
        }
    }
    
}
