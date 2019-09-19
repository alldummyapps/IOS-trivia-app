//
//  sportsVC.swift
//  BlackJackGame
//
//  Created by pc on 02/09/2019.
//  Copyright © 2019 yonsProject. All rights reserved.
//

import UIKit
import Firebase

class GameVC: UIViewController {
    //props:
    
    
    //outlets:
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answer1OL: UIButton!
    @IBOutlet weak var answer2OL: UIButton!
    @IBOutlet weak var answer3OL: UIButton!
    @IBOutlet weak var scoreOL: UILabel!
    
    //vars:
    var questionsDict:Dictionary<Int,String> = Dictionary<Int,String>()
    
    var randomIntOne:Int = Int()
    var randomIntTwo:Int = Int()
    var randomIntThree:Int = Int()
    var score:Int = Int()
    var oldUserScore:Int = Int()
    
    var counter:Int = Int()
    
    
    var firstQuestion = false
    var secondQuestion = false
    var thirdQuestion = false
    
    //firebase
    var mRef:DatabaseReference!
    var currentUserID:String?
    
    var gameCategory:String = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //counter for exiting the category to the categories menu:
        counter = 0
        //get the user proper category so the right questions will be showed:
        gameCategory = UserDefaults.standard.string(forKey: "category")!
        
        //init firebase refrence
        mRef = Database.database().reference()
        currentUserID = Auth.auth().currentUser?.uid
        
        
        
        //aligin the buttons in the gameVC:
        //allow multi questions line, center the buttons text
        aliginButtons()
        
        
        initUserScore()
        
        
        // init the questions datasource from the Datasoure file
        //with the right category
        if gameCategory.elementsEqual("sports"){
        questionsDict = DataSource.sportsDict.questionsDict
        }else if  gameCategory.elementsEqual("celebrities"){
            questionsDict = DataSource.celebritiesDict.questionsDict
        }else if  gameCategory.elementsEqual("science"){
        questionsDict = DataSource.scienceDict.questionsDict
        }else if  gameCategory.elementsEqual("geography"){
        questionsDict = DataSource.geographicDict.questionsDict
        }else if  gameCategory.elementsEqual("tvShows"){
        questionsDict = DataSource.tvShowsDict.questionsDict
        }else if  gameCategory.elementsEqual("history"){
        questionsDict = DataSource.historyDict.questionsDict
        }
        
        //roll a random number between 1 and 5 to show the first question:
        randomIntOne = Int.random(in: 1...5)
        
        
        //enable first question state:
        firstQuestion = true
        
        //show the first question:
        questionLabel.text = questionsDict[randomIntOne]
        
        //update the answers to fit the question:
        updateAnswers()
        
        
    }
    
    //retreive the user score from the database:
    func initUserScore(){
        
        mRef.child("users").child(currentUserID!).observe(DataEventType.value, with: { (snapShot) in
            
            
            let dict = snapShot.value as! Dictionary<String,Any>
            
           
            self.score = dict["score"] as! Int
            self.oldUserScore = dict["score"] as! Int
            
            self.scoreOL.text = String(dict["score"] as! Int)
        })
    }
    
    
    //updates the VC questions from the DataSource
    // depends on which category what choosen
    func setDatabase(){
        
        if gameCategory.elementsEqual("sports"){
            questionsDict = DataSource.sportsDict.questionsDict
        }else if  gameCategory.elementsEqual("celebrities"){
            questionsDict = DataSource.celebritiesDict.questionsDict
        }else if  gameCategory.elementsEqual("science"){
            questionsDict = DataSource.scienceDict.questionsDict
        }else if  gameCategory.elementsEqual("geography"){
            questionsDict = DataSource.geographicDict.questionsDict
        }else if  gameCategory.elementsEqual("tvShows"){
            questionsDict = DataSource.tvShowsDict.questionsDict
        }else if  gameCategory.elementsEqual("history"){
            questionsDict = DataSource.historyDict.questionsDict
        }
        
        
    }
    
    //answer one possibilitys:
    @IBAction func answer1Btn(_ sender: UIButton) {
        
        
        if firstQuestion{
            
            
            if randomIntOne == 1 {
                
                
                score += 10
                
                
            } else if randomIntOne == 2 {
                score += 10
                
            }else if randomIntOne == 3 {
                
                score -= 5
                
            }else if randomIntOne == 4 {
                
                
                score -= 5
                
            }else if randomIntOne == 5 {
                score += 10
                
                
            }
            
            
            
            randomIntOne = 0
            randomIntTwo = Int.random(in: 6...8)
            
            firstQuestion = false
            secondQuestion = true
            updateAnswers()
            
        }else if secondQuestion {
            
            
            
            
            if randomIntTwo == 6 {
                
                
                score += 10
            }else if randomIntTwo == 7 {
                
                
                score += 10
                
            }else if randomIntTwo == 8 {
                
                
                score -= 5
            }
            
            randomIntTwo = 0
            randomIntThree = Int.random(in: 9...10)
            
            
            secondQuestion = false
            thirdQuestion = true
            updateAnswers()
        }else if thirdQuestion {
            
            
            
            if randomIntThree == 9 {
                
                
                score  -= 5
                
            }else if randomIntThree == 10 {
                
                
                score += 10
            }
            
            thirdQuestion = false
            
        }
        
        counter += 1
        
        
   
        if(counter == 3){
           
            let finishAlert = UIAlertController(title: "Done with this round..", message: "Good Job, continue to another category!", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in

                Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "categoriesNavigation")

            }))

            present(finishAlert, animated: true, completion: nil)


        }
        scoreOL.text = String(score)
        
        //writes the user score to the user database:
        writeScoreToDatabase()
        

    }
    
    //answer two possibilitys:
    @IBAction func answer2Btn(_ sender: UIButton) {
        
        if firstQuestion {
            if randomIntOne == 1 {
                
                
                score -= 5
                
            } else if randomIntOne == 2 {
                
                
                score -= 5
            }else if randomIntOne == 3 {
                
                
                score -= 5
            }else if randomIntOne == 4 {
                
                
                score += 10
                
            }else if randomIntOne == 5 {
                
                
                score -= 5
            }
            
            randomIntOne = 0
            randomIntTwo = Int.random(in: 6...8)
            
            
            firstQuestion = false
            secondQuestion = true
            updateAnswers()
        }else if secondQuestion {
            
            
            if randomIntTwo == 6 {
                
                
                score -= 5
            }else if randomIntTwo == 7 {
                
                
                score -= 5
                
            }else if randomIntTwo == 8 {
                
                
                score += 10
            }
            
            randomIntTwo = 0
            randomIntThree = Int.random(in: 9...10)
            
            secondQuestion = false
            thirdQuestion = true
            updateAnswers()
        }else if thirdQuestion {
            
            
            if randomIntThree == 9 {
                
                
                score  -= 5
                
            }else if randomIntThree == 10 {
                
                
                score -= 5
            }
            
            thirdQuestion = false
            
        }
        
        counter += 1
        
        
        
        if(counter == 3){
         
            let finishAlert = UIAlertController(title: "Done with this round..", message: "Good Job, continue to another category!", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
                
                Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "categoriesNavigation")
                
            }))
            
            present(finishAlert, animated: true, completion: nil)
            
            
        }
        
        scoreOL.text = String(score)
        
         //writes the user score to the user database:
        writeScoreToDatabase()

        
    }
    
    //answer 3 posibilitys:
    @IBAction func answer3Btn(_ sender: UIButton) {
        
        
        if firstQuestion {
            if randomIntOne == 1 {
                
                
                score -= 5
                
            } else if randomIntOne == 2 {
                
                
                score -= 5
            }else if randomIntOne == 3 {
                
                
                score += 10
            }else if randomIntOne == 4 {
                
                
                score -= 5
            }else if randomIntOne == 5 {
                
                
                score -= 5
            }
            
            
            randomIntOne = 0
            randomIntTwo = Int.random(in: 6...8)
            
            
            firstQuestion = false
            secondQuestion = true
            updateAnswers()
        }else if secondQuestion {
            
            
            if randomIntTwo == 6 {
                
                
                score -= 5
            }else if randomIntTwo == 7 {
                
                
                score -= 5
                
            }else if randomIntTwo == 8 {
                
                
                score -= 5
            }
            
            randomIntTwo = 0
            randomIntThree = Int.random(in: 9...10)
            
            secondQuestion = false
            thirdQuestion = true
            updateAnswers()
        }else if thirdQuestion {
            
            if randomIntThree == 9 {
                
                
                score += 10
                
            }else if randomIntThree == 10 {
                
                
                score -= 5
            }
            
            thirdQuestion = false
            
            
        }
        
        counter += 1
        
        
        
        if(counter == 3){
            
            let finishAlert = UIAlertController(title: "Done with this round..", message: "Good Job, continue to another category!", preferredStyle: .alert)
            finishAlert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { (UIAlertAction) in
                
                Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "categoriesNavigation")
                
            }))
            
            present(finishAlert, animated: true, completion: nil)
            
            
        }
        
        scoreOL.text = String(score)
        
         //writes the user score to the user database:
    writeScoreToDatabase()
        
        
  
    }
    
    
    
    //updates the VC answers from the DataSource
    // depends on which category what choosen
    //
    func updateAnswers(){
        
        
        if gameCategory.elementsEqual("sports"){
            sportsDataChange()
        }else if  gameCategory.elementsEqual("celebrities"){
            celebritiesDataChange()
        }else if  gameCategory.elementsEqual("science"){
            scienceDataChange()
        }else if  gameCategory.elementsEqual("geography"){
            geographicDataChange()
        }else if  gameCategory.elementsEqual("tvShows"){
            tvShowsDataChange()
        }else if  gameCategory.elementsEqual("history"){
            historyDataChange()
        }
        
        
    }
    
    //datasources for the categories:
    //shows the right answers to each category:
    func sportsDataChange(){
        
        if firstQuestion{
            if randomIntOne == 1 {
                
                answer1OL.setTitle("RealMadrid", for: .normal)
                answer2OL.setTitle("Barcelona", for: .normal)
                answer3OL.setTitle("Manchester united", for: .normal)
            } else if randomIntOne == 2 {
                
                
                answer1OL.setTitle("Bayern Munich", for: .normal)
                answer2OL.setTitle("Barcelona", for: .normal)
                answer3OL.setTitle("LiverPool", for: .normal)
            }else if randomIntOne == 3 {
                
                
                answer1OL.setTitle("9", for: .normal)
                answer2OL.setTitle("13", for: .normal)
                answer3OL.setTitle("11", for: .normal)
            }else if randomIntOne == 4 {
                
                
                answer1OL.setTitle("60", for: .normal)
                answer2OL.setTitle("90", for: .normal)
                answer3OL.setTitle("120", for: .normal)
            }else if randomIntOne == 5 {
                
                
                answer1OL.setTitle("48", for: .normal)
                answer2OL.setTitle("54", for: .normal)
                answer3OL.setTitle("60", for: .normal)
            }
        } else if secondQuestion {
            questionLabel.text = questionsDict[randomIntTwo]
            
            if randomIntTwo == 6 {
                
                answer1OL.setTitle("8", for: .normal)
                answer2OL.setTitle("5", for: .normal)
                answer3OL.setTitle("6", for: .normal)
            } else if randomIntTwo == 7 {
                
                
                answer1OL.setTitle("18", for: .normal)
                answer2OL.setTitle("24", for: .normal)
                answer3OL.setTitle("16", for: .normal)
            }else if randomIntTwo == 8 {
                
                
                answer1OL.setTitle("6", for: .normal)
                answer2OL.setTitle("4", for: .normal)
                answer3OL.setTitle("2", for: .normal)
            }
            
            
            
        }else if thirdQuestion {
            questionLabel.text = questionsDict[randomIntThree]
            if randomIntThree == 9 {
                
                answer1OL.setTitle("240", for: .normal)
                answer2OL.setTitle("300", for: .normal)
                answer3OL.setTitle("360", for: .normal)
            } else if randomIntThree == 10 {
                
                
                answer1OL.setTitle("Alianz Arena", for: .normal)
                answer2OL.setTitle("Camp Nou", for: .normal)
                answer3OL.setTitle("sami ofer", for: .normal)
            }
            
            
        }
        
        
        
        
    }
    
    func historyDataChange(){
        
        if firstQuestion{
            if randomIntOne == 1 {
                
                answer1OL.setTitle("1989", for: .normal)
                answer2OL.setTitle("1979", for: .normal)
                answer3OL.setTitle("1990", for: .normal)
            } else if randomIntOne == 2 {
                
                
                answer1OL.setTitle("1918", for: .normal)
                answer2OL.setTitle("1939", for: .normal)
                answer3OL.setTitle("1941", for: .normal)
            }else if randomIntOne == 3 {
                
                
                answer1OL.setTitle("1917", for: .normal)
                answer2OL.setTitle("1945", for: .normal)
                answer3OL.setTitle("1914", for: .normal)
            }else if randomIntOne == 4 {
                
                
                answer1OL.setTitle("1973", for: .normal)
                answer2OL.setTitle("1969", for: .normal)
                answer3OL.setTitle("1952", for: .normal)
            }else if randomIntOne == 5 {
                answer1OL.setTitle("48 BC", for: .normal)
                answer2OL.setTitle("14 BC", for: .normal)
                answer3OL.setTitle("63 BC", for: .normal)
               
            }
        } else if secondQuestion {
            questionLabel.text = questionsDict[randomIntTwo]
            
            if randomIntTwo == 6 {
                
                answer1OL.setTitle("4.5B years ago", for: .normal)
                answer2OL.setTitle("13.4B years ago", for: .normal)
                answer3OL.setTitle("5B years ago", for: .normal)
            } else if randomIntTwo == 7 {
                
                
                answer1OL.setTitle("Graham Bell", for: .normal)
                answer2OL.setTitle("Tesala", for: .normal)
                answer3OL.setTitle("John Adams", for: .normal)
            }else if randomIntTwo == 8 {
                
                
                answer1OL.setTitle("1772", for: .normal)
                answer2OL.setTitle("1852", for: .normal)
                answer3OL.setTitle("1861", for: .normal)
            }
            
            
            
        }else if thirdQuestion {
            questionLabel.text = questionsDict[randomIntThree]
            if randomIntThree == 9 {
                
                answer1OL.setTitle("Moshe Sharet", for: .normal)
                answer2OL.setTitle("Izhak Shamir", for: .normal)
                answer3OL.setTitle("Ben Gurion", for: .normal)
            } else if randomIntThree == 10 {
                
                
                answer1OL.setTitle("John Hancock", for: .normal)
                answer2OL.setTitle("George washington", for: .normal)
                answer3OL.setTitle("John adams", for: .normal)
            }
            
            
        }
        
        
        
        
    }
    
    func scienceDataChange(){
        
        if firstQuestion{
            if randomIntOne == 1 {
                
                answer1OL.setTitle("Two thousand", for: .normal)
                answer2OL.setTitle("One thousand", for: .normal)
                answer3OL.setTitle("Seven hundreds ", for: .normal)
            } else if randomIntOne == 2 {
                
                
                answer1OL.setTitle("Jupiter", for: .normal)
                answer2OL.setTitle("Venus", for: .normal)
                answer3OL.setTitle("Earth", for: .normal)
            }else if randomIntOne == 3 {
                
                
                answer1OL.setTitle("Four", for: .normal)
                answer2OL.setTitle("Two", for: .normal)
                answer3OL.setTitle("Three", for: .normal)
            }else if randomIntOne == 4 {
                
                
                answer1OL.setTitle("Heart", for: .normal)
                answer2OL.setTitle("Liver", for: .normal)
                answer3OL.setTitle("Lung", for: .normal)
            }else if randomIntOne == 5 {
                
                
                answer1OL.setTitle("7", for: .normal)
                answer2OL.setTitle("5", for: .normal)
                answer3OL.setTitle("9", for: .normal)
            }
        } else if secondQuestion {
            questionLabel.text = questionsDict[randomIntTwo]
            
            if randomIntTwo == 6 {
                
                answer1OL.setTitle("B positive", for: .normal)
                answer2OL.setTitle("AB Negative", for: .normal)
                answer3OL.setTitle("O minus", for: .normal)
            } else if randomIntTwo == 7 {
                
                
                answer1OL.setTitle("Blue whale", for: .normal)
                answer2OL.setTitle("Elephant", for: .normal)
                answer3OL.setTitle("Giraffe", for: .normal)
            }else if randomIntTwo == 8 {
                
                
                answer1OL.setTitle("Gravitational energy", for: .normal)
                answer2OL.setTitle("Potential energy", for: .normal)
                answer3OL.setTitle("Kinetic energy", for: .normal)
            }
            
            
            
        }else if thirdQuestion {
            questionLabel.text = questionsDict[randomIntThree]
            if randomIntThree == 9 {
                
                answer1OL.setTitle("Herbivores", for: .normal)
                answer2OL.setTitle("Carnivores", for: .normal)
                answer3OL.setTitle("Omnivores", for: .normal)
            } else if randomIntThree == 10 {
                
                
                answer1OL.setTitle("Pancreas", for: .normal)
                answer2OL.setTitle("Heart", for: .normal)
                answer3OL.setTitle("Kidneys", for: .normal)
            }
            
            
        }
        
        
        
        
    }
    
    func celebritiesDataChange(){
        
        if firstQuestion{
            if randomIntOne == 1 {
                
                answer1OL.setTitle("Paris Hilton", for: .normal)
                answer2OL.setTitle("Christina Aguilera", for: .normal)
                answer3OL.setTitle("Anna Kournikova", for: .normal)
            } else if randomIntOne == 2 {
                
                
                answer1OL.setTitle("Christina Ricci", for: .normal)
                answer2OL.setTitle("Winona Rider", for: .normal)
                answer3OL.setTitle("Charlize Theron", for: .normal)
            }else if randomIntOne == 3 {
                
                
                answer1OL.setTitle("Clark Gable", for: .normal)
                answer2OL.setTitle("Isaac Asimov", for: .normal)
                answer3OL.setTitle("Rock Hudson", for: .normal)
                
            }else if randomIntOne == 4 {
                
                
                answer1OL.setTitle("Mike Tyson", for: .normal)
                answer2OL.setTitle("Michel Jackson", for: .normal)
                answer3OL.setTitle("Dennis Rodman", for: .normal)
                
            }else if randomIntOne == 5 {
                
                
                answer1OL.setTitle("Richard Pryor", for: .normal)
                answer2OL.setTitle("Chevy Chase", for: .normal)
                answer3OL.setTitle("Eddy Merphy", for: .normal)
            }
        } else if secondQuestion {
            questionLabel.text = questionsDict[randomIntTwo]
            
            if randomIntTwo == 6 {
                
                answer1OL.setTitle("Madona", for: .normal)
                answer2OL.setTitle("Janet Jackson", for: .normal)
                answer3OL.setTitle("Lady Gaga", for: .normal)
            } else if randomIntTwo == 7 {
                
                
                answer1OL.setTitle("Oprah Winfrey", for: .normal)
                answer2OL.setTitle("Jamse Franco", for: .normal)
                answer3OL.setTitle("David Duchovney", for: .normal)
            }else if randomIntTwo == 8 {
                
                
                answer1OL.setTitle("Sean Pen", for: .normal)
                answer2OL.setTitle("Tommy lee Joans", for: .normal)
                answer3OL.setTitle("steve Buscemi", for: .normal)
            }
            
            
            
        }else if thirdQuestion {
            questionLabel.text = questionsDict[randomIntThree]
            if randomIntThree == 9 {
                
                answer1OL.setTitle("Schizophrenic Postal Worker", for: .normal)
                answer2OL.setTitle("Olympian Gymnast", for: .normal)
                answer3OL.setTitle("Chatolic Priest", for: .normal)
            } else if randomIntThree == 10 {
                
                
                answer1OL.setTitle("4 Days", for: .normal)
                answer2OL.setTitle("4 Months", for: .normal)
                answer3OL.setTitle("4 Years", for: .normal)
            }
            
            
        }
        
        
        
        
    }
    
    func geographicDataChange(){
        
        if firstQuestion{
            if randomIntOne == 1 {
                
                answer1OL.setTitle("Asia", for: .normal)
                answer2OL.setTitle("Africa", for: .normal)
                answer3OL.setTitle("Europe", for: .normal)
            } else if randomIntOne == 2 {
                
                
                answer1OL.setTitle("Peru", for: .normal)
                answer2OL.setTitle("Chile", for: .normal)
                answer3OL.setTitle("Bolivia", for: .normal)
            }else if randomIntOne == 3 {
                
                
                answer1OL.setTitle("Jordan", for: .normal)
                answer2OL.setTitle("Karun", for: .normal)
                answer3OL.setTitle("Tigris", for: .normal)
            }else if randomIntOne == 4 {
                
                
                answer1OL.setTitle("Australia", for: .normal)
                answer2OL.setTitle("Canada", for: .normal)
                answer3OL.setTitle("Russia", for: .normal)
            }else if randomIntOne == 5 {
                
                
                answer1OL.setTitle("Sargasso Sea", for: .normal)
                answer2OL.setTitle("Adritic Sea", for: .normal)
                answer3OL.setTitle("Mediterranean Sea", for: .normal)
            }
        } else if secondQuestion {
            questionLabel.text = questionsDict[randomIntTwo]
            
            if randomIntTwo == 6 {
                
                answer1OL.setTitle("83%", for: .normal)
                 answer2OL.setTitle("22%", for: .normal)
                answer3OL.setTitle("9%", for: .normal)
            } else if randomIntTwo == 7 {
                
                
                answer1OL.setTitle("McMurdo, Antactica", for: .normal)
                answer2OL.setTitle("Sahara Desert", for: .normal)
                answer3OL.setTitle("Kufra Lybia", for: .normal)
            }else if randomIntTwo == 8 {
                
                
                answer1OL.setTitle("Columbia", for: .normal)
                answer2OL.setTitle("Chile", for: .normal)
                answer3OL.setTitle("Peru", for: .normal)
            }
            
            
            
        }else if thirdQuestion {
            questionLabel.text = questionsDict[randomIntThree]
            if randomIntThree == 9 {
                
                answer1OL.setTitle("Algeria", for: .normal)
                answer2OL.setTitle("Egypt", for: .normal)
                answer3OL.setTitle("Sudan", for: .normal)
            } else if randomIntThree == 10 {
                
                
                answer1OL.setTitle("Tunisia", for: .normal)
                answer2OL.setTitle("Gabon", for: .normal)
                answer3OL.setTitle("Ghana", for: .normal)
            }
            
            
        }
        
        
        
        
    }
    
    func tvShowsDataChange(){
        
        if firstQuestion{
            if randomIntOne == 1 {
                
                answer1OL.setTitle("Kathleen Turner", for: .normal)
                answer2OL.setTitle("Michel Dougles", for: .normal)
                answer3OL.setTitle("Elliot Gould", for: .normal)
            } else if randomIntOne == 2 {
                
                
                answer1OL.setTitle("Her Forhead", for: .normal)
                answer2OL.setTitle("Her Nose", for: .normal)
                answer3OL.setTitle("Her Ears", for: .normal)
            }else if randomIntOne == 3 {
                
                
                answer1OL.setTitle("Spiderman", for: .normal)
                answer2OL.setTitle("Batman", for: .normal)
                answer3OL.setTitle("Superman", for: .normal)
            }else if randomIntOne == 4 {
                
                
                answer1OL.setTitle("Family Fued", for: .normal)
                answer2OL.setTitle("Star Trek", for: .normal)
                answer3OL.setTitle("All in the family", for: .normal)
            }else if randomIntOne == 5 {
                
                
                answer1OL.setTitle("I Want to believe", for: .normal)
                answer2OL.setTitle("We are not alone", for: .normal)
                answer3OL.setTitle("I want to believe", for: .normal)
            }
        } else if secondQuestion {
            questionLabel.text = questionsDict[randomIntTwo]
            
            if randomIntTwo == 6 {
                
                answer1OL.setTitle("The adams Family", for: .normal)
                answer2OL.setTitle("All in the Family", for: .normal)
                answer3OL.setTitle("Maude", for: .normal)
            } else if randomIntTwo == 7 {
                
                
                answer1OL.setTitle("Kristin Shepard", for: .normal)
                answer2OL.setTitle("Jenna Wade", for: .normal)
                answer3OL.setTitle("Sue Ellen Ewing", for: .normal)
            }else if randomIntTwo == 8 {
                
                
                answer1OL.setTitle("Teal", for: .normal)
                answer2OL.setTitle("Yellow", for: .normal)
                answer3OL.setTitle("Pink", for: .normal)
            }
            
            
            
        }else if thirdQuestion {
            questionLabel.text = questionsDict[randomIntThree]
            if randomIntThree == 9 {
                
                answer1OL.setTitle("Mayberry R.F.D", for: .normal)
                answer2OL.setTitle("The Andy Griffith Show", for: .normal)
                answer3OL.setTitle("The Danny Thomas Show", for: .normal)
            } else if randomIntThree == 10 {
                
                
                answer1OL.setTitle("Dry Cleaner", for: .normal)
                answer2OL.setTitle("Gas Station", for: .normal)
                answer3OL.setTitle("Coffee Shop", for: .normal)
            }
            
            
        }
        
        
        
        
    }
    
     //writes the user score to the user database:
    func writeScoreToDatabase(){
        
        var dict:Dictionary<String,Any> = Dictionary<String,Any>()
        dict["score"] = score as! Int
        dict["scoreDate"] = Utilities.init().getDate() as! String
        mRef.child("users").child(currentUserID!).updateChildValues(dict)
        
    }
    
  
    //quit game btn
    //removes progress score
    //exit to main menu
    @IBAction func quitGameBtn(_ sender: UIButton) {
        
       let quitAlert = UIAlertController(title: "Quit Game", message: "Are you sure you want to go back to the main menu ?\n\n  All your progress will be lost.", preferredStyle: .alert)
        quitAlert.addAction(UIAlertAction(title: "I had enough", style: .destructive, handler: { (UIAlertAction) in
            
            
            //sets the old user score to the database:
            var dict:Dictionary<String,Int> = Dictionary<String,Int>()
            dict["score"] = self.oldUserScore
            
            self.mRef.child("users").child(self.currentUserID!).updateChildValues(dict)
            
            
             Utilities.init().sendToAnotherVC(vc: self, storyboard: self.storyboard!, identifier: "mainVCNavigation")
        }))
        quitAlert.addAction(UIAlertAction(title: "Stay for more", style: .default, handler: nil))
        
        present(quitAlert, animated: true, completion: nil)
        
    }
    
    //aligin the buttons to be in the right place:
    func aliginButtons() {
        //aligin the buttons in the gameVC:
        //allow multi questions line, center the buttons text
        answer1OL.titleLabel!.numberOfLines = 0
        answer1OL.titleLabel!.textAlignment = .center
        answer2OL.titleLabel!.numberOfLines = 0
        answer2OL.titleLabel!.textAlignment = .center
        answer3OL.titleLabel!.numberOfLines = 0
        answer3OL.titleLabel!.textAlignment = .center
    }
}
