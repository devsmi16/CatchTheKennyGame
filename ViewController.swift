import UIKit

class ViewController: UIViewController {
    
    //Variables
    var score = 0
    var timer = Timer()
    var hideTimer = Timer()
    var counter = 0
    var kennyArray = [UIImageView()]  // kenny'ler hareket etmesi için bunları dizi içine attık
    var highScoreValue = 0
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highScore: UILabel!
    
    
    //Views
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Score : \(score)"
        
        // HighScore Check
        let storedHighScore = UserDefaults.standard.object(forKey: "HighScore")
        
        if storedHighScore == nil{
            highScoreValue = 0
            highScore.text = "Highscore: \(highScoreValue)"
        }
        
        if let newScore = storedHighScore as? Int{
            highScoreValue = newScore
            highScore.text = "Highscore: \(highScoreValue)"
        }
        
        //Images
        
        kenny1.isUserInteractionEnabled  = true
        kenny2.isUserInteractionEnabled  = true
        kenny3.isUserInteractionEnabled  = true
        kenny4.isUserInteractionEnabled  = true
        kenny5.isUserInteractionEnabled  = true
        kenny6.isUserInteractionEnabled  = true
        kenny7.isUserInteractionEnabled  = true
        kenny8.isUserInteractionEnabled  = true
        kenny9.isUserInteractionEnabled  = true

        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))

        kenny1.addGestureRecognizer(recognizer1)
        kenny2.addGestureRecognizer(recognizer2)
        kenny3.addGestureRecognizer(recognizer3)
        kenny4.addGestureRecognizer(recognizer4)
        kenny5.addGestureRecognizer(recognizer5)
        kenny6.addGestureRecognizer(recognizer6)
        kenny7.addGestureRecognizer(recognizer7)
        kenny8.addGestureRecognizer(recognizer8)
        kenny9.addGestureRecognizer(recognizer9)

        kennyArray = [kenny1, kenny2, kenny3, kenny4, kenny5, kenny6, kenny7, kenny8, kenny9]      // kennyler hareket etmesi için
        hideKenny()
        
        //Timers
        counter = 10
        timeLabel.text = String(counter) // Stringe çevir
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(hideKenny), userInfo: nil, repeats: true)
    }
    
     
    @objc func hideKenny(){  // tüm kennyleri görünmez yaptık
        for kenny in kennyArray{
            kenny.isHidden = true
        }
        
        let random = Int(arc4random_uniform(UInt32(kennyArray.count - 1))) // dizide kaç taneyse bir eksiğini vermesi lazm random olarak. 0 la 8 arasında
        kennyArray[random].isHidden = false
        
    }


    @objc func increaseScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"  // score değişsin diye 2. kez yazdık
    }
    @objc func countDown(){
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate()
            hideTimer.invalidate()
            
            for kenny in kennyArray{ // bunu tekrar yaptık ki oyun bittikten sonra tüm kenny'leri tekrar gizlesin
                kenny.isHidden = true
            }
            
            
            //HighScore
            if self.score > self.highScoreValue {
                self.highScoreValue = self.score
                highScore.text = "Highscore: \(self.highScoreValue)"
                UserDefaults.standard.set(self.highScore, forKey: "highscore") // scoru kaydetmek için kullanıyoruz
            }
            
            
            //Alert
            let alert = UIAlertController(title: "Time's up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) { UIAlertAction in
                
                
                //Replay function
                self.score = 0
                self.scoreLabel.text = "Score: \(self.score)"
                self.counter = 10
                self.timeLabel.text = String(self.counter)     // sıfırlayıp label'a koydum
                
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.hideKenny), userInfo: nil, repeats: true)  
                // baştan başlatmak için
                
            }
            alert.addAction(okButton)
            alert.addAction(replayButton)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
