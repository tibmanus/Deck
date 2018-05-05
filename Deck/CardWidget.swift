//
//  CardWidget.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

class CardWidget: NSObject {
    
    let emoji : String
    let color : UIColor
    let rotation : CGFloat
    
    override init() {
        emoji = String(CardWidget.emojis[CardWidget.emojis.index(CardWidget.emojis.startIndex, offsetBy: CardWidget.emojis.count.arc4random)]) // pick a random image
        color = CardWidget.colors[CardWidget.colors.count.arc4random] // pick a random color
        rotation = (CGFloat.pi/8).arc4random // pick a random rotation
        super.init()
    }

    static var colors : [UIColor] = [ 
                               UIColor.darkGray,
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
    
    static let emojis = "🦁🐮🐅🦋🐛🐝🦄🦆🦉🦇🐺🐗🐴🐜🦖🐟"
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
