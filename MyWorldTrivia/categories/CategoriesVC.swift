//
//  CategoriesVC.swift
//  BlackJackGame
//
//  Created by pc on 02/09/2019.
//  Copyright © 2019 yonsProject. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController {
    

    @IBAction func toSports(_ sender: UIButton) {
      

        UserDefaults.standard.set("sports", forKey: "category")
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "gameVCNavigation")
    }
    
    @IBAction func toCelebrities(_ sender: UIButton) {
        
        UserDefaults.standard.set("celebrities", forKey: "category")
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "gameVCNavigation")
    }
    
    
    @IBAction func toGeographic(_ sender: UIButton) {
        
                UserDefaults.standard.set("geographic", forKey: "category")
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "gameVCNavigation")
    }
    
    
    @IBAction func toScience(_ sender: UIButton) {
        
                UserDefaults.standard.set("science", forKey: "category")
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "gameVCNavigation")
    }
    
    @IBAction func toHistory(_ sender: UIButton) {
        
                UserDefaults.standard.set("history", forKey: "category")
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "gameVCNavigation")
    }
    
    
    @IBAction func toTV(_ sender: UIButton) {
        
                UserDefaults.standard.set("tvShows", forKey: "category")
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "gameVCNavigation")
    }
    
    
    @IBAction func backToMainMenuBtn(_ sender: UIButton) {
        
        
        Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "mainVCNavigation")
        
        
    }
}
