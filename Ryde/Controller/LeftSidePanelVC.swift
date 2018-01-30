//
//  LeftSidePanelVC.swift
//  Ryde
//
//  Created by Sean Sutton on 1/5/18.
//  Copyright © 2018 Au Development. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {
    
    let appDelegate = AppDelegate.getAppDelegate()
    let currentUserId = Auth.auth().currentUser?.uid

    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var UserImageView: RoundImageView!
    @IBOutlet weak var pickupModeLbl: UILabel!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    @IBOutlet weak var userAccountTypeLbl: UILabel!
    @IBOutlet weak var loginOutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        pickupModeSwitch.isOn = false
        pickupModeLbl.isHidden = true
        pickupModeSwitch.isHidden = true
        
        observePassengersAndDrivers()
        
        if Auth.auth().currentUser == nil {
            userEmailLbl.text = ""
            userAccountTypeLbl.text = ""
            UserImageView.isHidden = true
            loginOutBtn.setTitle("Sign Up / Login", for: .normal)
        } else {
            userEmailLbl.text = Auth.auth().currentUser?.email
            userAccountTypeLbl.text = ""
            UserImageView.isHidden = false
            loginOutBtn.setTitle("Logout", for: .normal)
        }
        
    }
    
    func observePassengersAndDrivers() {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = "PASSENGER"
                    }
                }
            }
        })
        
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshot {
                    if snap.key == Auth.auth().currentUser?.uid {
                        self.userAccountTypeLbl.text = "DRIVER"
                        self.pickupModeSwitch.isHidden = false
                        
                        let switchStatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool
                        self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLbl.isHidden = false
                    }
                }
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchWasToggled(_ sender: Any) {
        if pickupModeSwitch.isOn {
            pickupModeLbl.text = "Pickup Mode Enabled"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled": true])
        } else {
            pickupModeLbl.text = "Pickup Mode Disabled"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues(["isPickupModeEnabled": false])
        }
    }
    
    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        } else {
            do {
                try Auth.auth().signOut()
                userEmailLbl.text = ""
                userAccountTypeLbl.text = ""
                UserImageView.isHidden = true
                pickupModeLbl.text = ""
                pickupModeSwitch.isHidden = true
                loginOutBtn.setTitle("Sign Up / Login", for: .normal)
            } catch (let error) {
                print(error)
            }
        }
    }
    


}
