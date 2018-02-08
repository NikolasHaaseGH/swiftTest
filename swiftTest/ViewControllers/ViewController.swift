//
//  ViewController.swift
//  swiftTest
//
//  Created by Nikolas Haase on 16.01.18.
//  Copyright © 2018 Nikolas Haase. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginAttempt(_ sender: UIButton) {
        let loginManager = LoginManager()
        
        loginManager.logIn(readPermissions: [ReadPermission.publicProfile, .email, .userEvents, .userLikes], viewController : self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                return
            case .cancelled:
                print("User cancelled login")
                return
            case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "tabViewController")
                self.present(controller, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func unwindToLogin(segue: UIStoryboardSegue){

    }
}

