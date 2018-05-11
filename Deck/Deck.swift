//
//  DeckWidget.swift
//  Deck
//
//  Created by Tibor Beke on 05/05/2018.
//  Copyright © 2018 Tibor Beke. All rights reserved.
//

import Foundation

class Deck {

    private static let numberOfCards = 10
    
    private(set) var cards = [Card]()
    
    init() {
        for _ in 1...Deck.numberOfCards {
            cards.append(Card())
        }
    }
}
