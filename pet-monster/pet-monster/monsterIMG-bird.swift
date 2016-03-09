//
//  monsterIMG-bird.swift
//  pet-monster
//
//  Created by Stanley on 2/19/16.
//  Copyright © 2016 Stanley. All rights reserved.
//

import Foundation
import UIKit

class MonsterIMGBird: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        playIdleAnimation()
    }
    
    func playIdleAnimation() {
        
        self.image = UIImage(named: "bird-idle1.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 3; x++ {
            let img = UIImage(named: "bird-idle\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 1.0
        self.animationRepeatCount = 0
        self.startAnimating()
        
    }
    
    func playDeathAnimation() {
        
        self.image = UIImage(named: "bird-death3.png")
        
        self.animationImages = nil
        
        var imgArray = [UIImage]()
        for var x = 1; x <= 3; x++ {
            let img = UIImage(named: "bird-death\(x).png")
            imgArray.append(img!)
        }
        
        self.animationImages = imgArray
        self.animationDuration = 1.0
        self.animationRepeatCount = 1
        self.startAnimating()
    }
    
}