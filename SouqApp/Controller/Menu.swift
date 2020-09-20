//
//  Menu.swift
//  SouqApp
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit

class Menu: UIViewController {
    
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblVersionNumber: UILabel!
    @IBOutlet weak var btnLogout: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            lblVersionNumber.text = version
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundView.layer.cornerRadius = 14.0
        roundView.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let name = UserDefaults.standard.string(forKey: "name")
        if name == nil {
            btnLogin.setTitle("Sigin / Signup", for: .normal)
        } else {
            btnLogin.setTitle(name, for: .normal)
        }
        
    }
    
    @IBAction func btnCloseMenu(_ sender: Any) {
       NotificationCenter.default.post(name: NSNotification.Name("CloseMenu"), object: nil)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func btnTellAFriend(_ sender: Any) {
        let text = "Hey! Lets shopping on SouqApp \(kAPPURL)"
        let objectsToShare: [Any] = [text]
        let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue("Lets shopping on SouqApp", forKey: "subject")
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnTermsAndConditions(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TermsAndConditions") as! TermsAndConditions
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func btnLogout(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: "logged")
        UserDefaults.standard.set("Sigin / Signup", forKey: "name")
        UserDefaults.standard.synchronize()
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
