//
//  GameViewController.swift
//  BlackJack21
//
//  Created by Yoga on 2023/8/1.
//

import UIKit

class GameViewController: UIViewController {
    
    
    @IBOutlet var computerCardView: [UIView]!
    @IBOutlet var computerSuit1Label: [UILabel]!
    @IBOutlet var computerSuit2Label: [UILabel]!
    @IBOutlet var computerRankLabel: [UILabel]!
    @IBOutlet weak var computerSumLabel: UILabel!
    
    
    @IBOutlet var playerCardView: [UIView]!
    @IBOutlet var playerSuit1Label: [UILabel]!
    @IBOutlet var playerSuit2Label: [UILabel]!
    @IBOutlet var playerRankLabel: [UILabel]!
    @IBOutlet weak var playerSumLabel: UILabel!
    
    @IBOutlet weak var betLabel: UILabel!
    @IBOutlet weak var chipsLabel: UILabel!
    @IBOutlet weak var betMoneyLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    
    @IBOutlet weak var moneyBackground: UIImageView!
    @IBOutlet weak var betBackground: UIImageView!
    @IBOutlet weak var betMoneyBackground: UIImageView!
    
    
    var cards = [Card]()
    var computerCards = [Card]()
    var playerCards = [Card]()
    
    var ownMoney = 2000 //設定籌碼
    var betMoney = 0 //下注金額
    var index = 1 //要牌數量．因一開始預設先發兩張牌
    
    //計算computerCards總和
    var cptSum: Int {
        var cptSum = 0
        for i in computerCards{
            cptSum += calculateRankNumber(card: i)
        }
        return cptSum
    }
    
    //計算playerCards總和
    var playerSum: Int {
        var playerSum = 0
        for i in playerCards{
            playerSum += calculateRankNumber(card: i)
        }
        return playerSum
    }
    
    //生成空的52組牌，存在cards的陣列中
    func updateUI(){
        for suit in suits{
            for rank in ranks{
                cards.append(Card(suit: suit, rank: rank))
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moneyBackground.layer.cornerRadius = 20
        betBackground.layer.cornerRadius = 20
        betMoneyBackground.layer.cornerRadius = 20
        
        updateUI()
        gameStart()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func gameStart(){
        index = 1
        computerCards = [Card]()
        playerCards = [Card]()
        //使用 for in 迴圈在畫面上放上 5 張撲克牌
        for i in 0...4{
            if i < 2{
                computerCardView[i].isHidden = false
                playerCardView[i].isHidden = false
                cards.shuffle() //洗牌，不洗牌面會從suit[0],rank[0]黑桃A開始
                computerCards.append(cards[i])
                cards.shuffle() //再次洗牌，不然會顯示跟computer相同
                playerCards.append(cards[i])
                computerRankLabel[i].text = computerCards[i].rank
                computerSuit1Label[i].text = computerCards[i].suit
                computerSuit2Label[i].text = computerCards[i].suit
                playerRankLabel[i].text = playerCards[i].rank
                playerSuit1Label[i].text = playerCards[i].suit
                playerSuit2Label[i].text = playerCards[i].suit
                computerSumLabel.text = "\(cptSum)"
                playerSumLabel.text = "\(playerSum)"
            }else{
                computerCardView[i].isHidden = true
                playerCardView[i].isHidden = true
            }
            
        }
    }
    
    
    //算牌面點數
    func calculateRankNumber(card:Card) -> Int {
        var cardRankNumber = 0
        switch card.rank{
        case "A":
            cardRankNumber = 1
        case "J","Q","K":
            cardRankNumber = 10
        default:
            cardRankNumber = Int(card.rank)!
        }
        return cardRankNumber
    }
    
    //控制籌碼金額，籌碼總額為2000，加減籌碼一次100，籌碼歸零即遊戲結束
    @IBAction func betMoneyControl(_ sender: UIButton) {
        if sender == addButton {
            if ownMoney >= 100 {
                betMoney += 100
                ownMoney -= 100
            }
            
        }
        if sender == minusButton{
            if betMoney >= 100{
                betMoney -= 100
                ownMoney += 100
            }
            
        }
        //賭金不為負數
        if betMoney < 0 {
            betMoney = 0
        }//當籌碼歸零時，遊戲重新開始，籌碼為2000
        else if ownMoney < 0 {
            ownMoney = 0
            gameStart()
        }
        chipsLabel.text = "\(ownMoney)"
        betLabel.text = "\(betMoney)"
        betMoneyLabel.text = "\(betMoney)"
        
    }
    
    //要牌
    @IBAction func hit(_ sender: UIButton) {
        //有下籌碼才可以開始要牌
        if checkBetMoney()==true{
            index = index+1
            cards.shuffle()
            playerCardView[index].isHidden = false
            playerCards.append(cards[index])
            playerRankLabel[index].text = playerCards[index].rank
            playerSuit1Label[index].text = playerCards[index].suit
            playerSuit2Label[index].text = playerCards[index].suit
            playerSumLabel.text = "\(playerSum)"
            
            //當卡牌為5張且＜21點，過五關，獎金2倍；當卡牌=21點，贏回賭金；當卡牌>21，輸掉賭金
            if checkOwnMoney() == true{
                if index == 4 , playerSum<=21{
                    gameAlert(title: "恭喜過五關！", message: "贏回賭金兩倍！")
                    ownMoney += betMoney+betMoney+betMoney
                    betMoney -= betMoney
                    chipsLabel.text = "\(ownMoney)"
                    betLabel.text = "\(betMoney)"
                    betMoneyLabel.text = "\(betMoney)"
                }else if playerSum==21{
                    gameAlert(title: "恭喜!", message: "21點獲勝！")
                    ownMoney += betMoney+betMoney
                    betMoney -= betMoney
                    chipsLabel.text = "\(ownMoney)"
                    betLabel.text = "\(betMoney)"
                    betMoneyLabel.text = "\(betMoney)"
                }else if playerSum>21{
                    gameAlert(title: "爆掉了！", message: "超過21點！")
                    betMoney -= betMoney
                    chipsLabel.text = "\(ownMoney)"
                    betLabel.text = "\(betMoney)"
                    betMoneyLabel.text = "\(betMoney)"
                }
            }
            
        }
    }
    
    //開牌，玩家認為點數夠了可選擇停牌，點數即固定
    @IBAction func stand(_ sender: UIButton) {
        
        if  checkBetMoney()==true{
            //當電腦牌面點數<=17，繼續抽牌
            if cptSum<=17{
                //當電腦牌面點數<=21繼續抽牌，且莊家<玩家時，繼續補牌最多5張
                for i in 2...4{
                    if cptSum<=21{
                        computerCards.append(cards[i])
                        computerCardView[i].isHidden = false
                        computerRankLabel[i].text = computerCards[i].rank
                        computerSuit1Label[i].text = computerCards[i].suit
                        computerSuit2Label[i].text = computerCards[i].suit
                        computerSumLabel.text = "\(cptSum)"
                        //當電腦牌面點數=21，電腦獲勝
                        if cptSum == 21{
                          //  ownMoney = ownMoney-betMoney
                            betMoney -= betMoney
                            gameAlert(title: "21點！", message: "電腦獲勝！")
                            chipsLabel.text = "\(ownMoney)"
                            betLabel.text = "\(betMoney)"
                            betMoneyLabel.text = "\(betMoney)"
                        }//當電腦牌面點數>21，電腦輸玩家獲勝
                        else if cptSum>21{
                            ownMoney += betMoney+betMoney
                            betMoney -= betMoney
                            gameAlert(title: "電腦爆掉啦！", message: "恭喜玩家獲勝！")
                            chipsLabel.text = "\(ownMoney)"
                            betLabel.text = "\(betMoney)"
                            betMoneyLabel.text = "\(betMoney)"
                        }//當電腦過五關且牌面比玩家大，電腦獲勝
                        else if i==4 && cptSum<=21 && cptSum>playerSum{
                          //  ownMoney = ownMoney-betMoney
                            betMoney -= betMoney
                            gameAlert(title: "可惜了！電腦過五關！", message: "電腦獲勝！")
                            
                        }
                    }
                    
                }
            }else {
                if cptSum<playerSum{
                    ownMoney += betMoney+betMoney
                    betMoney -= betMoney
                    gameAlert(title: "你比電腦大啦！", message: "玩家獲勝！")
                    chipsLabel.text = "\(ownMoney)"
                    betLabel.text = "\(betMoney)"
                    betMoneyLabel.text = "\(betMoney)"
                }else if cptSum>playerSum{
                  //  ownMoney -= betMoney
                    betMoney -= betMoney
                    gameAlert(title: "哭哭！電腦比你大！", message: "電腦獲勝！")
                    chipsLabel.text = "\(ownMoney)"
                    betLabel.text = "\(betMoney)"
                    betMoneyLabel.text = "\(betMoney)"
                }else if cptSum == playerSum{
                    ownMoney = ownMoney+betMoney
                    betMoney -= betMoney
                    gameAlert(title: "電腦跟你點數一樣大！", message: "平手！！！")
                    chipsLabel.text = "\(ownMoney)"
                    betLabel.text = "\(betMoney)"
                    betMoneyLabel.text = "\(betMoney)"
                }
            }
            
        }
            
        }
        
    //棄牌時，賭金只能回收一半，重新發牌
    @IBAction func giveup(_ sender: UIButton) {
        if checkBetMoney()==true{
            ownMoney += betMoney/2
            betMoney -= betMoney
            chipsLabel.text = "\(ownMoney)"
            betLabel.text = "\(betMoney)"
            betMoneyLabel.text = "\(betMoney)"
            gameStart()
        }
    }
    
    
    
    //遊戲結果的提醒框
    func gameAlert(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "再玩一次！", style: UIAlertAction.Style.default) { okAction in
            self.gameStart()
        }
        controller.addAction(okAction)
        present(controller, animated: true,completion: nil)
        
    }
    
    //檢查是否下賭金的提醒框．未下賭金不會開始遊戲
    func betMoneyAlert(title: String, message: String){
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { okAction in
            controller.dismiss(animated: true, completion: nil)
        }
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }
    
    //確認賭金
    func checkBetMoney()->Bool?{
        if betMoney <= 0{
            betMoneyAlert(title: "注意！", message: "請下注才能開始遊戲喔！")
            return false
        }else{
            return true
        }
    }
    
    //確認籌碼
    func checkOwnMoney()->Bool?{
        if ownMoney <= 0{
            return false
        }else{
            return true
        }
        
    }
    
}
