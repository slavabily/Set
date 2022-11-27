//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Game {
    var cards = [Card]()
    
    init(quantityOfCards: Int) {
        for _ in 0..<quantityOfCards {
            let card = Card(symbol: Symbol())
            cards.append(card)
        }
    }
}

struct Card {
    let symbol: Symbol
    let quantityOfSymbols = (1...3).randomElement()  
}

struct Symbol {
    let shape: Shape
    let look: Look
    let color: Color
    
    init() {
        shape = .allCases.randomElement()!
        look = .allCases.randomElement()!
        color = .allCases.randomElement()!
    }
    
    enum Shape: CaseIterable {
        case rectangle
        case capsule
        case diamond
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case blue
    }
    
    enum Look: CaseIterable {
        case stroked
        case filled
        case shaded
    }
}

