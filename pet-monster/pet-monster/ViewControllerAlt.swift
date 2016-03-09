//
//  ViewControllerAlt.swift
//  pet-monster
//
//  Created by Stanley on 2/20/16.
//  Copyright © 2016 Stanley. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class ViewControllerAlt: UIViewController {
    
    
    @IBOutlet weak var birdImage: MonsterIMGBird!
    @IBOutlet weak var fruitImage: DragFile!
    @IBOutlet weak var candyImage: DragFile!
    @IBOutlet weak var oneupImage: DragFile!
    @IBOutlet weak var penalty1IMG: UIImageView!
    @IBOutlet weak var penalty2IMG: UIImageView!
    @IBOutlet weak var penalty3IMG: UIImageView!
    @IBOutlet weak var restartBtn: UIButton!
    
    let DIM_ALPHA: CGFloat = 0.2
    let OPAGUE: CGFloat = 1.0
    let MAX_PENALTIES = 3
    
    var penalties = 0
    var timer: NSTimer!
    var monsterHappy = false
    var currentItem: UInt32 = 0
    var gameStart = 0
    
    var musicPlayer: AVAudioPlayer!
    var sfxBite: AVAudioPlayer!
    var sfxCandy: AVAudioPlayer!
    var sfxDeath: AVAudioPlayer!
    var sfxSkull: AVAudioPlayer!
    var sfxOneup: AVAudioPlayer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fruitImage.dropTarget = birdImage
        candyImage.dropTarget = birdImage
        oneupImage.dropTarget = birdImage
        
        penalty1IMG.alpha = DIM_ALPHA
        penalty2IMG.alpha = DIM_ALPHA
        penalty3IMG.alpha = DIM_ALPHA
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "itemDroppedOnCharacter:", name: "onTargetDropped", object: nil)
        
        do {
            let resourcePath = NSBundle.mainBundle().pathForResource("kirby-music",  ofType: "mp3")!
            let url = NSURL(fileURLWithPath: resourcePath)
            try musicPlayer = AVAudioPlayer(contentsOfURL: url)
            
            try sfxBite = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kirby-bite", ofType: "wav")!))
            
            try sfxCandy = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kirby-candy", ofType: "wav")!))
            
            try sfxDeath = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kirby-death", ofType: "mp3")!))
            
            try sfxSkull = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kirby-skull", ofType: "wav")!))
            try sfxOneup = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("kirby-oneup", ofType: "wav")!))
            
            musicPlayer.prepareToPlay()
            musicPlayer.play()
            
            sfxBite.prepareToPlay()
            sfxCandy.prepareToPlay()
            sfxDeath.prepareToPlay()
            sfxSkull.prepareToPlay()
            sfxOneup.prepareToPlay()
            
        } catch let err as NSError {
            print (err.debugDescription)
        }
        
        startTimer()
        generateItem()
    }
    
    func itemDroppedOnCharacter(notif: AnyObject) {
        monsterHappy = true
        startTimer()
        
        fruitImage.alpha = DIM_ALPHA
        fruitImage.userInteractionEnabled = false
        candyImage.alpha = DIM_ALPHA
        candyImage.userInteractionEnabled = false
        oneupImage.alpha = DIM_ALPHA
        oneupImage.userInteractionEnabled = false
        
        if currentItem == 0 {
            sfxCandy.play()
        } else if currentItem == 1 {
            sfxBite.play()
        } else {
            sfxOneup.play()
        }
    }
    
    func startTimer() {
        if timer != nil {
            timer.invalidate()
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: "ChangeGameState", userInfo: nil, repeats: true)
    }
    
    
    func ChangeGameState() {
        
        
        if !monsterHappy {
            
            penalties++
            
            sfxSkull.play()
            
            if penalties == 1 {
                penalty1IMG.alpha = OPAGUE
                penalty2IMG.alpha = DIM_ALPHA
            } else if penalties == 2 {
                penalty2IMG.alpha = OPAGUE
                penalty3IMG.alpha = DIM_ALPHA
            } else if penalties >= 3 {
                penalty3IMG.alpha = OPAGUE
            } else {
                penalty1IMG.alpha = DIM_ALPHA
                penalty2IMG.alpha = DIM_ALPHA
                penalty3IMG.alpha = DIM_ALPHA
            }
            
            if penalties >= MAX_PENALTIES {
                GameOver()
                candyImage.alpha = DIM_ALPHA
                candyImage.userInteractionEnabled = false
                fruitImage.alpha = DIM_ALPHA
                fruitImage.userInteractionEnabled = false
                return
            }
        }
        generateItem()
    }
    
    func generateItem() {
        let rand = arc4random_uniform(3) // grab 0 or 1 or 2 *edited
        
        
        if rand == 0 {
            fruitImage.alpha = DIM_ALPHA
            fruitImage.userInteractionEnabled = false
            oneupImage.alpha = DIM_ALPHA
            oneupImage.userInteractionEnabled = false
            
            candyImage.alpha = OPAGUE
            candyImage.userInteractionEnabled = true
        }
        else if rand == 1{
            candyImage.alpha = DIM_ALPHA
            candyImage.userInteractionEnabled = false
            oneupImage.alpha = DIM_ALPHA
            oneupImage.userInteractionEnabled = false
            
            fruitImage.alpha = OPAGUE
            fruitImage.userInteractionEnabled = true
        } else {
            candyImage.alpha = DIM_ALPHA
            candyImage.userInteractionEnabled = false
            fruitImage.alpha = DIM_ALPHA
            fruitImage.userInteractionEnabled = false
            
            oneupImage.alpha = OPAGUE
            oneupImage.userInteractionEnabled = true
            
        }
        currentItem = rand
        monsterHappy = false
    }
    
    func GameOver() {
        timer.invalidate()
        birdImage.playDeathAnimation()
        sfxDeath.play()
        musicPlayer.stop()
        restartBtn.hidden = false
    }
    
    @IBAction func restartGame(sender: AnyObject) {
        if sfxDeath.play() {
            sfxDeath.stop()
        }
        restartBtn.hidden = true
        penalties = 0
        startTimer()
        musicPlayer.play()
        birdImage.playIdleAnimation()
        generateItem()
        penalty1IMG.alpha = DIM_ALPHA
        penalty2IMG.alpha = DIM_ALPHA
        penalty3IMG.alpha = DIM_ALPHA
    }
    
}

