//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

struct Game {
    var cards = [Card]()
    
    init(quantityOfCards: Int) {
        while cards.count < quantityOfCards {
            let card = Card(symbol: Symbol())
            
            // TODO: algorithm of unique cards creation
            if !cards.contains(where: {
                $0 == card
            }) {
                cards.append(card)
            }   
        }
        
        print("Cards quantity: \(cards.count)")
        
        let uniqueCards = cards.removingDuplicates()
        
        print("Unique cards quantity: \(uniqueCards.count)")
    }
}

struct Card: Equatable, Hashable {
    let symbol: Symbol
    let quantityOfSymbols = (1...3).randomElement()
}

struct Symbol: Equatable, Hashable {
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

