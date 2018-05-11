//
//  CardWidget.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

class Card : Equatable {
    
    let emoji : String
    let color : UIColor
    let rotation : CGFloat
    var position : Int = 0
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.emoji == rhs.emoji
            && lhs.color == rhs.color
            && lhs.rotation == rhs.rotation
    }
    
    init() {
        if (Card.emojis.count > 0) {
            let stringIndex = Card.emojis.index(Card.emojis.startIndex, offsetBy: Card.emojis.count.arc4random)
            emoji = String(Card.emojis.remove(at: stringIndex)) // pick a random image
        } else {
            emoji = "❓"
        }
        if (Card.colors.count > 0) {
            color = Card.colors.remove(at: Card.colors.count.arc4random) // pick a random color
        } else {
            color = UIColor.clear
        }
        rotation = (CGFloat.pi/8).arc4random // pick a random rotation
    }
    
    static var colors = [UIColor.darkGray,
                         UIColor.lightGray,
                         UIColor.white,
                         UIColor.gray,
                         UIColor.red,
                         UIColor.green,
                         UIColor.blue,
                         UIColor.cyan,
                         UIColor.yellow,
                         UIColor.magenta,
                         UIColor.orange,
                         UIColor.purple,
                         UIColor.brown]
    
    static var emojis = "🦁🐮🐅🦋🐛🐝🦄🐖🦆🦉🐉🦇🐺🐗🐴🐜🦖🐟"
}


extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        return self * (CGFloat(arc4random_uniform(UInt32.max))/CGFloat(UInt32.max))
    }
}
