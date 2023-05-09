//
//  GameViewController.swift
//  Barabara
//
//  Created by 杉井位次 on 2023/05/09.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    @IBOutlet var imageView3: UIImageView!
    
    @IBOutlet var resultLabel: UILabel!
    
    var timer: Timer!
    
    var score: Int = 1000
    
    let saveData: UserDefaults = UserDefaults.standard
    
    //画面サイズを取得
    let width: CGFloat = UIScreen.main.bounds.size.width
    
    //画像の位置の配列　座標は左上が原点とする
    var positionX: [CGFloat] = [0.0, 0.0, 0.0]

    //画像を動かす幅の配列
    var dx: [CGFloat] = [1.0, 0.5, -1.0]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //画像の位置を画面幅の中心に設定
        positionX = [width/2, width/2, width/2]
        self.start()
    }
    
    func start() {
         //結果ラベルを非表示にする
        resultLabel.isHidden = true
        
        //タイマーを動かす
        timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(self.up), userInfo: nil, repeats: true)
        timer.fire()
    }
    
    @objc func up() {
        for i in 0..<3 {
            //端に来たら動かす方向を逆向きにする
            if positionX[i] > width || positionX[i] < 0 {
                dx[i] = dx[i] * -1
            }
            //画像の位置をdx分ずらす
            positionX[i] += dx[i]
        }
        //画像をずらした位置に移動させる
        imageView1.center.x = positionX[0]
        imageView2.center.x = positionX[1]
        imageView3.center.x = positionX[2]
    }
    
    @IBAction func stop() {
        //もしタイマーが動いていたら
        if timer.isValid == true {
            //タイマーを止める
            timer.invalidate()
        }
        
        for i in 0..<3 {
            //スコアを計算する
            //abs(--)は真ん中からどれだけずれているか絶対値を計算する
            score = score - abs(Int(width/2 - positionX[i]))*2
        }
        
        resultLabel.text = "Score:　" + String(score)
        //結果ラベルを表示する
        resultLabel.isHidden = false
        
        let highScore1: Int = saveData.integer(forKey: "score1")
        let highScore2: Int = saveData.integer(forKey: "score2")
        let highScore3: Int = saveData.integer(forKey: "score3")
        
        if score > highScore1 {
            saveData.set(score, forKey: "score1")
            saveData.set(highScore1, forKey: "score2")
            saveData.set(highScore2, forKey: "score3")
        } else if score > highScore2 {
            saveData.set(score, forKey: "score2")
            saveData.set(highScore2, forKey: "score3")
        } else if score > highScore3 {
            saveData.set(score, forKey: "score3")
        }
        
        
    }
    
    @IBAction func retry() {
        score = 1000
        positionX = [width/2, width/2, width/2]
        //もしタイマーが動いていなければ
        if timer.isValid == false {
            self.start()
        }
    }
    
    //前の画面に戻るメソッド
    @IBAction func toTop() {
        self.dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
