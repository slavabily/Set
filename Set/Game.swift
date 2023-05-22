//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Game {
    
    struct Constants {
        static let sizeOfDeck = 24
        static let dealtCards = 12
        static let openedCards = 3
    }
    
    enum Alert {
        case setIsRemoved
        case itIsNotASet
        case open3MoreCards
        case `default`
    }
    
    private(set) var alert: Alert = .default
    private(set) static var deck = [Card]()
    private(set) static var cardsOnTheTable = [Card]()
    private(set) static var discardedCards = [Card]()
    private var trueSet = [Card]()
    private var setToCompare = [Card]()
    private var selectedCards = [Card]()
    
    private var initiallyDealtCards: [Card] {
        deal(from: Self.deck)
    }
    
    private func deal(from cards: [Card]) -> [Card] {
        var deck = cards
        var dealtCards = [Card]()
        repeat {
            let dealtCard = cards.randomElement()
            deck.removeAll(where: { $0 == dealtCard })
            if !dealtCards.contains(where: { $0 == dealtCard }) {
                dealtCards.append(dealtCard!)
            }
        } while dealtCards.count < Constants.dealtCards
        Self.deck = deck
        return dealtCards
    }
    
    @discardableResult
    init() {
        repeat {
            let card = Card(symbol: Symbol())
            if !Self.deck.contains(where: { $0 == card }) {
                Self.deck.append(card)
            }
        } while Self.deck.count < Self.Constants.sizeOfDeck
        Self.cardsOnTheTable = initiallyDealtCards
        findTrueSet_()
        Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        Self.discardedCards.removeAll()
    }
    
    mutating func open3Cards() {
        var cardsOnTheTablePlusOpenedCards = Self.cardsOnTheTable
        repeat {
            guard Self.deck.count > 0 else { return }
            let card = Self.deck.randomElement()
            Self.deck.removeAll(where: {$0 == card})
            if !cardsOnTheTablePlusOpenedCards.contains(where: { $0 == card }) {
                cardsOnTheTablePlusOpenedCards.append(card!)
            }
        } while cardsOnTheTablePlusOpenedCards.count < Self.cardsOnTheTable.count + Constants.openedCards
        Self.cardsOnTheTable = cardsOnTheTablePlusOpenedCards
        
        findTrueSet_()
        
        if selectedCards.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        }
        alert = .default
    }
    
    mutating func findTrueSet() {
        if findTrueSet_() {
            alert = .default
        } else {
            alert = .open3MoreCards
        }
    }
    
    mutating func newGame() {
        Self.init()
        alert = .default
    }
    
    
    @discardableResult
    private mutating func findTrueSet_() -> Bool {
        trueSet.removeAll()
        selectedCards.removeAll()
        Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        for card1 in Self.cardsOnTheTable {
            for card2 in Self.cardsOnTheTable {
                for card3 in Self.cardsOnTheTable {
                    if card1 == card2 || card2 == card3 || card1 == card3 {
                        continue
                    } else {
                        if card1.symbol.shape == card2.symbol.shape && card2.symbol.shape == card3.symbol.shape,
                           card1.quantityOfSymbols == card2.quantityOfSymbols && card2.quantityOfSymbols == card3.quantityOfSymbols
                        {
                            trueSet = [card1, card2, card3]
                            trueSet.forEach({ mark($0, with: .fromTrueSet)})
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    mutating func selectCard(_ card: Card) {
        alert = .default
        if !trueSet.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
            setToCompare = trueSet
            trueSet.removeAll()
        }
        if card.status == .default || card.status == .fromTrueSet {
            
            if selectedCards.count < 3 {
                mark(card, with: .selected)
                selectedCards.append(card)

                if !setToCompare.isEmpty, selectedCards.count == setToCompare.count {
                    var difference = [Card]()
                    setToCompare.forEach({card in
                        if let card = selectedCards.first(where: {$0.symbol != card.symbol && $0.quantityOfSymbols != card.quantityOfSymbols}) {
                            difference.append(card)
                        }
                    })
                    if difference.isEmpty {
                        alert = .setIsRemoved
                        selectedCards.forEach { card in
                            if let index = Self.cardsOnTheTable.firstIndex(where: {$0.symbol == card.symbol && $0.quantityOfSymbols == card.quantityOfSymbols}) {
                                Self.cardsOnTheTable.remove(at: index)
                                
                                //  2) : Leaving fewer cards on the table
                                
//                                if let newCard = Self.deck.randomElement(), !Self.cardsOnTheTable.contains(where: {$0 == newCard}) {
//                                    Self.cardsOnTheTable.insert(newCard, at: index)
//                                    Self.deck.remove(at: Self.deck.firstIndex(of: newCard)!)
//                                }
                                
                                // Adding removed cards to 'discardedCards'
                                Self.discardedCards.append(card)
                            }
                        }
                        findTrueSet_()
                        if selectedCards.isEmpty {
                            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
                        }
                    } else {
                        alert = .itIsNotASet
                    }
                } else if setToCompare.isEmpty {
                    alert = .itIsNotASet
                }
            } else {
                selectedCards.forEach({mark($0, with: .default)})
                selectedCards.removeAll()
            }
        } else {
            mark(card, with: .default)
            selectedCards.removeAll(where: {$0.symbol == card.symbol && $0.quantityOfSymbols == card.quantityOfSymbols})
        }
    }
    
    private func mark(_ card: Card, with: Card.Status) {
        var newCard = card
        switch with {
        case .default:
            newCard.status = .default
        case .fromTrueSet:
            newCard.status = .fromTrueSet
        case .selected:
            newCard.status = .selected
        }
        replace(card, by: newCard)
    }
    
    private func replace(_ card: Card, by tapped: Card) {
        if let index = Self.cardsOnTheTable.firstIndex(where: { $0.symbol == card.symbol && $0.quantityOfSymbols == card.quantityOfSymbols }) {
            Self.cardsOnTheTable.remove(at: index)
            Self.cardsOnTheTable.insert(tapped, at: index)
        }
    }
}

struct Card: Equatable, Hashable {
    let symbol: Symbol
    let quantityOfSymbols = (1...3).randomElement()
    var status: Status = .default
    
    enum Status {
        case `default`
        case selected
        case fromTrueSet
    }
    
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

