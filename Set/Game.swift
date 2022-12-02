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
            
            // TODO: algorithm of unique cards creation
            
            if !cards.contains(where: {
                $0.symbol == card.symbol
            
            }) {
                cards.append(card)
            }
        }
        print("Cards quantity: \(cards.count)")
    }
}

struct Card {
    let symbol: Symbol
    let quantityOfSymbols = (1...3).randomElement()
}

struct Symbol: Equatable {
    let shape: Shape
    let color: Color
    let look: Look
    
    init() {
        shape = .allCases.randomElement()!
        color = .allCases.randomElement()!
        look = .allCases.randomElement()!
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

