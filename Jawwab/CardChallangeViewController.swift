//
//  CardChallangeViewController.swift
//  Jawwab
//
//  Created by Latif Ath on 4/6/19.
//  Copyright © 2019 atheer. All rights reserved.
//

import UIKit
import Firebase
import ARKit

class CardChallangeViewController: UIViewController {
    
    
var counrer = 0
     var ref: DatabaseReference!
    let userId = UserDefaults.standard.object(forKey: "userId") as? String
    let lang = UserDefaults.standard.object(forKey: "lang") as? Int
    
    // ======== Missing : Pop up at the beggining & AR & Navigation & Rewards update
    
    
    @IBOutlet weak var fullnametext: UILabel!
    @IBOutlet weak var card1: UILabel!
    
    @IBOutlet weak var card2: UILabel!
    @IBOutlet weak var card3: UILabel!
    @IBOutlet weak var card4: UILabel!
    @IBOutlet weak var card5: UILabel!
    @IBOutlet weak var card6: UILabel!
    
    @IBOutlet weak var card1eng: UILabel!
    
    @IBOutlet weak var card2eng: UILabel!
    
    @IBOutlet weak var card3eng: UILabel!
    
    @IBOutlet weak var card4eng: UILabel!
    
    @IBOutlet weak var card5eng: UILabel!
    
    @IBOutlet weak var card6eng: UILabel!
    
    @IBOutlet weak var popupx: UIButton!
    @IBOutlet weak var headerpopup: UILabel!
    @IBOutlet weak var nicetry: UILabel!
    @IBOutlet weak var niicetrypopup: UILabel!
    
    @IBOutlet weak var boyhappy: UIImageView!
    @IBOutlet weak var popup: UIImageView!
    
    @IBOutlet weak var exc: UILabel!
    
    @IBOutlet weak var fullname: UIImageView!
    
    
    // (Note)
        // Lazy allows us to use instance variable "cardButtons", because it should
        // be already initialized by the time a lazy var is used.'
        
        ///
        /// Model - The actual game logic is contained in Concentration
        ///
        private  var game: Concentration!
        
        // Programming assignment 1 (Task #4 & extra-credit #1)
        //
        // "Give your game the concept of a 'theme'. A theme determines the set of emoji from
        // which cards are chosen"
        //
        // +Extra credit:
        // "Change the background and the 'card back color' to match the theme"
        
        ///
        /// The theme determines the game's look and feel.
        ///
        var theme: Theme!
        
        /// Label that shows how many flips we've done
 
        
        /// Array of cards in the UI
        @IBOutlet private var cardButtons: [UIButton]!
        
        // The cardButtons that are visible (Ugh, this is so ugly)
        private var visibleCardButtons: [UIButton]! {
            return cardButtons?.filter { !$0.superview!.isHidden }
        }
        
        // Update UI every time we get subviews laid out
        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            updateUIFromModel()
        }
        
        ///
        /// Handle the touch (press) of a card
        ///
        @IBAction private func touchCard(_ sender: UIButton) {
            // Get the index of the selected/touched card
            if let cardNumber = visibleCardButtons.index(of: sender) {
                // Tell the model which card was chosen
                game.chooseCard(at: cardNumber)
                
                // Update the view accordingly
                updateUIFromModel()
            }
            else {
                print("Warning! The chosen card was not in visibleCardButtons")
            }
        }
        
        // Programming assignment 1 (Task #3):
        // Add a “New Game” button to your UI which ends the current game in progress and
        // begins a brand new game.
        
        /// Start a new game
   
        
        ///
        /// The number of pairs of cards in the game
        ///
        var numberOfPairsOfCards: Int {
            return (visibleCardButtons.count + 1)/2
        }
        
        ///
        /// Setups a new game
        ///
        private func initialSetup() {
            // Create new Concentration game
            game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
            
            // Match board color (view's background) with the current theme color
            self.view.backgroundColor = theme.boardColor
            
            // Get emojis for each card
            mapCardsToEmojis()
            
            // Update cards view
            updateUIFromModel()
        }
        
        ///
        /// Function that creates an attributed string (i.e. string with "visual" style),
        /// which is explained (and used) in Lecture #4: "More Swift"
        ///
        private func attributedString(_ text: String) -> NSAttributedString {
            let attributes: [NSAttributedString.Key : Any] = [
                .strokeColor : UIColor.red,
                .strokeWidth : -2.0
            ]
            return NSAttributedString(string: text, attributes: attributes)
        }
        
        ///
        /// Keeps the UI updated based on the model's state
        ///
        private func updateUIFromModel() {
            
            // (Intentionally skipping this variation based on size classes)
            //        // Example to vary this based on size class:
            //        if traitCollection.verticalSizeClass == .compact {
            //            flipCountLabel.attributedText = attributedString("Flip count: \(game.flipCount)")
            //        }
            //        else {
            //            flipCountLabel.attributedText = attributedString("Flip count:\n\(game.flipCount)")
            //        }
            
            // Update flip count label (using NSAttributedString as seen on Lecture #4)
            if(game.finished){
            
                popupx.isHidden = false
                headerpopup.isHidden = false
                nicetry.isHidden = false
                niicetrypopup.isHidden = false
                popup.isHidden = false
                boyhappy.isHidden = false
                self.solveChallange(q: 2, status: 1)
                self.setCurrent(q: 2)
                self.updateRewards()
            }
            
            // Loop through each card (we care about the index only)
            for index in visibleCardButtons.indices {
                // Get the button at current indext
                let button = visibleCardButtons[index]
                
                // Get the card (from the model) at the current index
                let card = game.cards[index]
                
                // If card is face-up, show it
                if card.isFaceUp {
                    // Show the card's emoji
                    button.setBackgroundImage(UIImage(named: emoji(for: card)), for: UIControl.State.normal)
                    if(emoji(for: card) == "card1"){
                        card1.isHidden = false
                    }
                    if(emoji(for: card) == "card1eng"){
                        card1eng.isHidden = false
                    }
                    if(emoji(for: card) == "card2"){
                        card2.isHidden = false
                    }
                    if (emoji(for: card) == "card2eng"){
                        card2eng.isHidden = false
                    }
                    if (emoji(for: card) == "card3eng"){
                        card3eng.isHidden = false
                    }
                    if(emoji(for: card) == "card3" ){
                        card3.isHidden = false
                    }
                    if(emoji(for: card) == "card4"){
                        card4.isHidden = false
                    }
                    if (emoji(for: card) == "card4eng"){
                        card4eng.isHidden = false
                    }
                    if(emoji(for: card) == "card5"){
                        card5.isHidden = false
                    }
                    if (emoji(for: card) == "card5eng"){
                        card5eng.isHidden = false
                    }
                    if(emoji(for: card) == "card6eng"){
                        card6eng.isHidden = false
                    }
                    if(emoji(for: card) == "card6"){
                        card6.isHidden = false
                    }
                //    button.setTitle(emoji(for: card), for: .normal)
                    // Set a "face-up" color
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                    // If card is not face-up, could be (1) face-up or (2) matched/hidden
                else {
                    // No emoji when card is down or already matched
                    button.setBackgroundImage(UIImage(named: ""), for: UIControl.State.normal)
                    
                    // If card is matched, hide it (with clear color), else show a "face-down" color
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : theme.cardColor
                }
            }
        }
        
        // (Intentionally skipping this variation based on size classes)
        //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //        super.traitCollectionDidChange(previousTraitCollection)
        //        updateUIFromModel()
        //    }
        
        // Setup/configure stuff as soon as the view loads
        override func viewDidLoad() {
            super.viewDidLoad()
            if(lang == 0){
                theme = defaultTheme
                
            }
            if (lang == 1){
                theme = engTheme
                fullname.image = UIImage(named:"prophetNameEng.png")
                fullnametext.text = "Prophet Mohammed ’s full name"
                
            }
            
            card1.isHidden = true
            card2.isHidden = true
            card3.isHidden = true
            card4.isHidden = true
            card5.isHidden = true
            card6.isHidden = true
            card1eng.isHidden = true
            card2eng.isHidden = true
            card3eng.isHidden = true
            card4eng.isHidden = true
            card5eng.isHidden = true
            card6eng.isHidden = true
            popupx.isHidden = true
            headerpopup.isHidden = true
            nicetry.isHidden = true
            niicetrypopup.isHidden = true
            popup.isHidden = true
            boyhappy.isHidden = true
            // Do initialSetup
            initialSetup()
        }
        
        ///
        /// Each card/button will have a corresponding emoji
        ///
        private var emoji = [Card: String]()
        
        ///
        /// Get an emoji for the given card
        ///
        private func emoji(for card: Card) -> String {
            // Return the emoji, or "?" if none available
            return emoji[card] ?? "?"
        }
        
        ///
        /// Assign an emoji for each card identifier
        ///
        private func mapCardsToEmojis() {
            
            // List of emojis available for the current theme
            var emojis = theme.emojis
            
            // Suffle them (to have slighlty different emojis with each new game)
            emojis.shuffle()
            
            for card in game.cards {
                // Make sure emojis has item(s) and the card is not set yet
                if !emojis.isEmpty, emoji[card] != nil {
                    // Assign emoji
                    emoji[card] = emojis.removeFirst()
                }
                else {
                    emoji[card] = "?"
                }
            }
        }
    
    func solveChallange(q: Int, status: Int){
        ref = Database.database().reference()
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        // 0 ==> not solved  // 1 ==> solved
        self.ref.child("tour").child(userId!).updateChildValues(["q\(q)": status])
        if (status == 1) {
          //  self.saveScore()
         //   self.updateRewards()
        }
    }
    
    func setCurrent(q: Int){
        ref = Database.database().reference()
        var userId = UserDefaults.standard.object(forKey: "userId") as? String
        self.ref.child("tour").child(userId!).updateChildValues(["current": q])
        
    }
    
    func updateRewards(){
        let userId = UserDefaults.standard.object(forKey: "userId") as? String
        ref = Database.database().reference()
        
        let userscore = ref.child("users").child(userId!).child("UserScore")
        userscore.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let score = snapshot.value as? String{
                var score1 = Int(score)
                score1 = score1! + 10
                self.passingScore(score1: score1!)
            }
        })
        
    }
    
    
    func passingScore(score1: Int){
        ref = Database.database().reference()
        let score2 = String(score1)
        ref.child("users").child(userId!).child("UserScore").setValue(score2)
      //  rewards.text = "\(score1)"
    }
 /*
    @IBAction func skipBtn(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let skipViewController = storyBoard.instantiateViewController(withIdentifier: "skip") as! skipViewController
        
        self.present(skipViewController, animated: false, completion: nil)
        
    }
    
    */
    ///
        /// Represents the game's theme.
        ///
        /// For instance, a "halloween" theme might contain a dark (black) board with orange
        /// cards and a set of "scary" emojis.
        ///
        struct Theme {
            /// The name of the theme (i.e. to show it on screen or something)
            var name: String
            
            /// The color of the board
            var boardColor: UIColor
            
            /// The color of the card's back
            var cardColor: UIColor
            
            /// Array of available emojis fot the theme
            var emojis: [String]
        }
        
        ///
        /// The default theme to use
        ///
        private var defaultTheme = Theme(name: "Default", boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1), cardColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                         emojis: ["card1", "card2", "card3", "card4", "card5", "card6",])
    
    private var engTheme = Theme(name: "Default", boardColor: #colorLiteral(red: 0.9678710938, green: 0.9678710938, blue: 0.9678710938, alpha: 1), cardColor: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1),
                                 emojis: ["card1eng", "card2eng", "card3eng", "card4eng", "card5eng", "card6eng",])
    }



