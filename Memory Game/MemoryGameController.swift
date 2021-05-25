import UIKit

class MemoryGameController: UIViewController {
    
        
    @IBOutlet weak var game_LBL_timer: UILabel!
    @IBOutlet weak var game_LBL_moves: UILabel!
    @IBOutlet var gameMemory_board_cards: [UIButton]!

    private let images = [#imageLiteral(resourceName: "004-astronaut"),#imageLiteral(resourceName: "005-black hole"),#imageLiteral(resourceName: "006-destroyed"),#imageLiteral(resourceName: "001-alien"),#imageLiteral(resourceName: "002-Asteroid"),#imageLiteral(resourceName: "003-astronaut")]
    var bourd:[UIImage] = []
    private let backCard = #imageLiteral(resourceName: "p0")
    private let matrixCard = 12
    private var click=0
    private var firstimage=#imageLiteral(resourceName: "p0")
    private var firstTag=0
    private var countOfSuccess=0
    private var countOfMoves=30
    private var duration=0
    private var timer = Timer()
    private var firstClick:UIButton? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initGame()
        
    }
    
    func initGame(){
        print("\(gameMemory_board_cards.count)")
        for card in gameMemory_board_cards{
            card.setImage(backCard, for:.normal)
        }
        shuffle()
        countOfMoves=30
        countOfSuccess=0
        game_LBL_moves.text=String(countOfMoves)
        game_LBL_timer.text = "00:00"
        setTimer(on: true, timerLabel: game_LBL_timer)
        enableAllCards()
        
    }
    
    func shuffle(){
        for image in images {
            self.bourd.append(image)
            self.bourd.append(image)
        }
        self.bourd.shuffle()
    }
    func enableAllCards() -> Void {
        self.gameMemory_board_cards.forEach { card in card.isEnabled=true
        }
    }
    
    @IBAction func clickButton(_ sender: UIButton) {
        if(click==1)
        {
            if(firstClick==sender)//click on the same image
            {
                return;
            }
            sender.setImage(bourd[sender.tag], for: .normal)//change the image
           
            
            if(bourd[sender.tag]==bourd[firstClick!.tag])//chack if same image
            {
                sender.isEnabled = false
                firstClick?.isEnabled = false
                countOfSuccess+=1
                
            }
            else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                    sender.setImage(self.backCard, for: .normal)
                    self.firstClick!.setImage(self.backCard, for: .normal)
                    
                }
               
            }
            click=0
            countOfMoves-=1
            game_LBL_moves.text=String(countOfMoves)
            if(isTheGameOver())
            {
                setTimer(on: false, timerLabel: game_LBL_timer)
                if(isUserWon()){
                    alertPlayAgain(titel: "Congratulation!", msg: "You won!")
                }
                else{
                    //if user lost
                    alertPlayAgain(titel: "Sorry ", msg: "You lost, better luck next time!")
                }
                
            }
            return;
        }
        sender.setImage(bourd[sender.tag], for: .normal)
        click+=1
        firstClick=sender
    
    }
    func isTheGameOver() -> Bool {
        if(countOfSuccess==bourd.count/2 || countOfMoves==0){
                return true
        }
        return false
    }
    func isUserWon() ->Bool{
        return (countOfSuccess==bourd.count/2)
    }
    
    
    func setTimer(on: Bool, timerLabel: UILabel){
            if(on) {//run timer each second
                duration = 0
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    self.duration += 1
                    let seconds = String(format: "%02d", (self.duration%60))
                    let minutes = String(format: "%02d", self.duration/60)
                    timerLabel.text = "\(minutes):\(seconds)"
                }
            }
            else {
                timer.invalidate()//pause
            
            }
        }
	
func alertPlayAgain(titel: String, msg: String) {
        let alert = UIAlertController(title: titel, message: msg ,preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Play again", style: .default,handler: { (action) -> Void in
            self.initGame()
           
        })
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
