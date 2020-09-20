//
//  TermsAndConditions.swift
//  SouqApp
//
//  Created by Ahmed.
//  Copyright © 2019 Ahmed. All rights reserved.
//

import UIKit

class TermsAndConditions: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func btnBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
