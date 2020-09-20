//
//  Login.swift
//  SouqApp
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit
import Alamofire

class Login: UIViewController {
    
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPhone.layer.cornerRadius = 5.0
        txtPhone.layer.borderColor = UIColor.black.cgColor
        txtPhone.layer.borderWidth = 1.0
        txtPassword.layer.cornerRadius = 5.0
        txtPassword.layer.borderColor = UIColor.black.cgColor
        txtPassword.layer.borderWidth = 1.0
        btnSignIn.layer.cornerRadius = 5.0
        btnSignIn.layer.borderColor = UIColor.black.cgColor
        btnSignIn.layer.borderWidth = 1.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "logged") == true {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    @IBAction func btnX(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCreatAccount(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUp") as! SignUp
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func btnHidePassword(_ sender: Any) {
        if(txtPassword.isSecureTextEntry == false){
            txtPassword.isSecureTextEntry = true
        } else {
            txtPassword.isSecureTextEntry = false
        }
    }
    
    @IBAction func btnSignin(_ sender: Any) {
        Alamofire.request("\(Constants.api_link)log-in/en", method: .post, parameters: ["phone":"\(txtPhone.text!))","password":txtPassword.text!], encoding: JSONEncoding.default)
            .responseJSON { (response) in
                if let res = response.result.value {
                    if let d = res as? NSDictionary {
                        let valid = d["valid"] as! Int
                        switch valid {
                        case 0:
                            let alertController = UIAlertController(title: "Error", message: "Please Enter Valid Phone And Password", preferredStyle: .alert)
                            let cancelButton = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(cancelButton)
                            self.present(alertController, animated: true, completion: nil)
                        default:
                            User.id = d["user_id"] as! Int
                            self.dismiss(animated: true, completion: nil)
                            UserDefaults.standard.set(true, forKey: "logged")
                            UserDefaults.standard.set(self.txtPhone.text!, forKey: "name")
                            UserDefaults.standard.synchronize()
                    }
                }
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
