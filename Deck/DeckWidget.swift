//
//  DeckWidget.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import UIKit

class DeckWidget: NSObject {

    private static let numberOfCards = 10
    
    private(set) var cards = [Card:CardWidget]()
    
    override init() {
        for _ in 1...DeckWidget.numberOfCards {
            cards[Card()] = CardWidget()
        }
        
        super.init()
    }
}
