//
//  LeaderboardsTVC.swift
//  BlackJackGame
//
//  Created by pc on 01/09/2019.
//  Copyright © 2019 yonsProject. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardsTVC: UITableViewController {
    
    
    //properties:
    
    //fire base:
    var mRef:DatabaseReference!
    
    //vars:
    var userID:String?
    var data:[DataSnapshot] = [DataSnapshot]()
    var currentDate:[String:String] = [String:String]()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //checks if a user is logged in -> if so continue to main VC
        //else -> send user to login VC
        checkCurrentUser()
        
        //firebase init:
        userID = Auth.auth().currentUser!.uid
        mRef = Database.database().reference()
        
        //data init:
        initFireBase()


        //sets the navigation bar color to black
        self.navigationController!.navigationBar.barStyle = .black
    }
    
    
    
    //event listner to the firebase - > if there is a new entry -> add all the entrys into the dataSnapshot array -> 'data'
    // aterwards insert the values into the tableView:
    //adds the users IDS into an array to be used later to write the users requests to the database
    func initFireBase(){
        
        
        
        mRef.child("users").observe(DataEventType.value, with: { (dataSnapShot) in
            //loop of the children of the users -> id > data
            for snap in dataSnapShot.children {
                
                let userSnap = snap as! DataSnapshot
                
                //users ID array:
                let uid = userSnap.key //the uid of each user
                
                
              
                    
                    self.mRef.child("users").child(uid).observe(DataEventType.value, with: { (snapShot) in
                        
                        
                        //insert the user data into data array and send it to the tableView:
                        self.data.append(snapShot)
                        self.tableView.insertRows(at: [IndexPath(row: self.data.count - 1 , section: 0)], with: .automatic)
                        
                        
                        
                    })
                
            }
        })
        
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leaderboardsCell", for: indexPath) as! LeaderboardsCell

      
        let userData = data[indexPath.row]
        
        let userDetails = userData.value as! Dictionary<String,Any>
        
        
        let profilePic = userDetails[Constants.usersFields.userProfilePic] ?? ""
        let nickName = userDetails[Constants.usersFields.nickName] ?? "Jon Due"
        let email = userDetails[Constants.usersFields.email] ?? ""
        let currentTime = userDetails[Constants.usersFields.scoreDate] ?? ""
           let score = userDetails[Constants.usersFields.score] ?? ""
        
        let stringScore = String(score as! Int)
        
        cell.userNickName.text = nickName as! String
        cell.userRecordDate.text = currentTime as! String
        cell.userEmail.text = email as! String
        cell.userScore.text = stringScore as! String
        
        
        //insert the profile pic of the user into the selected view:
        if let url = URL(string: profilePic as! String){
            
            do {
                let data = try Data(contentsOf: url)
                cell.userProfilePic.image = UIImage(data: data)
                
            }catch let err {
                print(" Error : \(err.localizedDescription)")
            }
        

       
    }
        
         return cell
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


}
