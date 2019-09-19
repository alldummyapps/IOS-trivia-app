//
//  MainMenuVC.swift
//  BlackJackGame
//
//  Created by pc on 01/09/2019.
//  Copyright © 2019 yonsProject. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class MainMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checks if a user is logged in -> if so continue to main VC
        //else -> send user to login VC
        checkCurrentUser()
        
        
        
        
        //sets the navigation bar color to black
self.navigationController!.navigationBar.barStyle = .black
    }
    

   
    
    @IBAction func logOutBtn(_ sender: UIButton) {
        
        
        logout()
        checkCurrentUser()
    }
    
    
    @IBAction func aboutBtn(_ sender: UIButton) {
    }
    
    //log out the user of the app
    //if it trows an error the catch phrase will 'catch' that error
    func logout() {
        
        let fAuth =  Auth.auth()
        
        do{
            try fAuth.signOut()
        }catch let signOutError as NSError{
            
            print("error siging out " + signOutError.localizedDescription)
        }
        
        
    }
    
    
    //checks if a user is logged in -> if so continue to main VC
    //else -> send user to login VC
    func checkCurrentUser () {
        
        if(Auth.auth().currentUser  == nil){
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "authVC") {
                self.navigationController?.present(vc, animated: true, completion: nil)
                
            }
        }
        
    }

    @IBAction func newGameBtn(_ sender: UIButton) {
        
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "categoriesNavigation")
    }
}
