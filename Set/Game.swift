//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Game {
    static var cardsOnTheTable = [Card]()
    private var allCards = [Card]()
    
    private var initiallyDealtCards: [Card] {
        var dCards = [Card]()
        repeat {
            let dealtCard = allCards.randomElement()
            if !dCards.contains(where: { $0 == dealtCard }) { dCards.append(dealtCard!)}
        } while dCards.count < 12
        return dCards
    }
    
    init() {
        repeat {
            let card = Card(symbol: Symbol())
            if !allCards.contains(where: { $0 == card }) {
                allCards.append(card)
            }   
        } while allCards.count < 81
        
        Self.cardsOnTheTable = initiallyDealtCards
    }
    
    mutating func open3Cards() {
        guard Self.cardsOnTheTable.count < 21 else { return }
        var cardsOnTheTablePlusOpenedCards = Self.cardsOnTheTable
        repeat {
            let card = allCards.randomElement()
            if !cardsOnTheTablePlusOpenedCards.contains(where: { $0 == card }) {
                cardsOnTheTablePlusOpenedCards.append(card!)
            }
        } while cardsOnTheTablePlusOpenedCards.count < Self.cardsOnTheTable.count + 3
        
        Self.cardsOnTheTable = cardsOnTheTablePlusOpenedCards
        print("\(Self.cardsOnTheTable.count)")
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

