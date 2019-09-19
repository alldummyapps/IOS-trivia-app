//
//  LeaderboardsCell.swift
//  BlackJackGame
//
//  Created by pc on 01/09/2019.
//  Copyright © 2019 yonsProject. All rights reserved.
//

import UIKit

class LeaderboardsCell: UITableViewCell {

    
    //props:
    //outlets:
    @IBOutlet weak var userRecordDate: UILabel!
    
    @IBOutlet weak var userNickName: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var userScore: UILabel!
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    //bubble shape view:
    override func layoutSubviews() {
        super.layoutSubviews()
    
            userProfilePic.layer.cornerRadius =  userProfilePic.frame.height / 2
    }
    
    

}
