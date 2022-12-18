//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Game {
    private var allCards = [Card]()
    static var cardsOnTheTable = [Card]()
    private var trueSet: [Card]?
    
    private var isCardSelected = false
    
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
    }
    
    mutating func selectCard(_ card: Card) {
        var selectedCard = card
        if !isCardSelected {
            selectedCard.backgroundColor = .yellow
            if let index = Self.cardsOnTheTable.firstIndex(where: { $0 == card }) {
                Self.cardsOnTheTable.remove(at: index)
                Self.cardsOnTheTable.insert(selectedCard, at: index)
            }
            
            // TODO: _
            // 1) collect 3 selected cards into the 'previousSet';
            // 2) check if 'previousSet' is identical to the 'trueSet';
            // 3) if yes - remove the true set from the 'cardsOnThetable' and from the 'allCards' respectively and replace removed cards by new ones from the deck;
            // 4) if no - deselect the cards selected and empty the previous set.
            
            
            isCardSelected = true
        } else {
            selectedCard.backgroundColor = .white
            if let index = Self.cardsOnTheTable.firstIndex(where: { $0 == card }) {
                Self.cardsOnTheTable.remove(at: index)
                Self.cardsOnTheTable.insert(selectedCard, at: index)
            }
            isCardSelected = false
        }
    }
    
    mutating func findSet() {
        for card1 in Self.cardsOnTheTable {
            for card2 in Self.cardsOnTheTable {
                for card3 in Self.cardsOnTheTable {
                    if card1 == card2 || card2 == card3 || card1 == card3 {
                        continue
                    } else {
                        //MARK: checking if cards conform to the set rules
                        if card1.symbol.shape == card2.symbol.shape && card2.symbol.shape == card3.symbol.shape,
                           card1.quantityOfSymbols == card2.quantityOfSymbols && card2.quantityOfSymbols == card3.quantityOfSymbols
                        {
                            // create the new cards with same properties but another background color
                            [card1, card2, card3].forEach({ replace($0)}) 
                        }
                    }
                }
            }
        }
    }
    
    private func replace(_ card: Card) {
        var newCard = card
        newCard.backgroundColor = .pink
        if let index = Self.cardsOnTheTable.firstIndex(where: { $0 == card }) {
            Self.cardsOnTheTable.remove(at: index)
            Self.cardsOnTheTable .insert(newCard, at: index)
        }
    }
}

struct Card: Equatable, Hashable {
    let symbol: Symbol
    let quantityOfSymbols = (1...3).randomElement()
    var backgroundColor: BackgroundColor = .white
    
    enum BackgroundColor {
        case white
        case yellow
        case pink
    }
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

