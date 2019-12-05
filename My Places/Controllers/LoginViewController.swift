//
//  LoginViewController.swift
//  My Places
//
//  Created by Jassem Al-Buloushi on 12/2/19.
//  Copyright © 2019 Jassem Al-Buloushi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet var emailTextField: UITextField!
    
    @IBOutlet var passwordTextField: UITextField!
    
    @IBOutlet var topButton: UIButton!
    
    @IBOutlet var bottomButton: UIButton!
    
    //Variables
    var signUpMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - My Methods
    
    func displayAlert(title: String, message: String) {
        
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(ac, animated: true, completion: nil)
        
    }
    
    
    //MARK: - IB Actions
    
    @IBAction func topButtonPressed(_ sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            displayAlert(title: "Missing Information", message: "You must provide both email and password ")
            
            
        } else {
            
            if let email = emailTextField.text {
                
                if let password = passwordTextField.text {
                    
                    if signUpMode {
                        
                        //SIGNUP
                        
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            
                            if error != nil {
                                
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                
                            } else {
                                
                                print("Signup Success!!")
                                
                                self.performSegue(withIdentifier: "mapSegue", sender: nil)
                                
                            }
                            
                        }
                        
                        
                    } else {
                        
                        //LOGIN
                        
                        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                            
                            if error != nil {
                                
                                self.displayAlert(title: "Error", message: error!.localizedDescription)
                                
                            } else {
                                
                                print("Login Success!!")
                                
                                self.performSegue(withIdentifier: "mapSegue", sender: nil)
                                
                            }
                            
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func bottomButtonPressed(_ sender: UIButton) {
        
        if signUpMode {
            
            topButton.setTitle("Log In", for: .normal)
            
            bottomButton.setTitle("Switch to Signup", for: .normal)
            
            signUpMode = false
            
        } else {
            
            topButton.setTitle("Sign Up", for: .normal)
            
            bottomButton.setTitle("Switch to Login ", for: .normal)
            
            signUpMode = true
            
        }
        
        
    }
    
    
    
}

