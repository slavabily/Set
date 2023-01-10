//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Game {
    
    struct Constats {
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
    private var trueSet = [Card]()
    private var setToCompare = [Card]()
    private var selectedCards = [Card]()
    
    private var initiallyDealtCards: [Card] {
        deal(from: Self.deck)
    }
    
    private func deal(from cards: [Card]) -> [Card] {
        var dCards = [Card]()
        repeat {
            let dealtCard = cards.randomElement()
            Self.deck.removeAll(where: { $0 == dealtCard })
            print("Deck size: \(Self.deck.count)")
            if !dCards.contains(where: { $0 == dealtCard }) {
                dCards.append(dealtCard!)
            }
        } while dCards.count < Self.Constats.dealtCards
        return dCards
    }
    
    init() {
        repeat {
            let card = Card(symbol: Symbol())
            if !Self.deck.contains(where: { $0 == card }) {
                Self.deck.append(card)
            }   
        } while Self.deck.count < Self.Constats.sizeOfDeck
        Self.cardsOnTheTable = initiallyDealtCards
        findTrueSet_()
        if selectedCards.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        }
        print("Deck size after first deal: \(Self.deck.count)")
    }
    
    mutating func open3Cards() {
        var cardsOnTheTablePlusOpenedCards = Self.cardsOnTheTable
        
    // TODO:   do subtraction from the deck only when opening 3 more cards!
        repeat {
            guard Self.deck.count > 0 else { return }
            if let card = Self.deck.randomElement() {
                if !cardsOnTheTablePlusOpenedCards.contains(where: { $0 == card }) {
                    cardsOnTheTablePlusOpenedCards.append(card)
                }
            } else {
                break
            }
        } while cardsOnTheTablePlusOpenedCards.count < Self.cardsOnTheTable.count + Constats.openedCards
        
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
        if !trueSet.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
            setToCompare = trueSet
            trueSet.removeAll()
            return
        }
        if card.status == .default || card.status == .fromTrueSet {
            
            if selectedCards.count < 3 {
                mark(card, with: .selected)
                selectedCards.append(card)
                
                if !setToCompare.isEmpty, selectedCards.count == setToCompare.count {
                    let difference = setToCompare.difference(from: selectedCards)
                    print("difference: \(difference)")
                    
                    if difference.isEmpty {
                        alert = .setIsRemoved
                        setToCompare.forEach({ card in
                            Self.deck.removeAll(where: {$0 == card})
                            
                            if let index = Self.cardsOnTheTable.firstIndex(where: {$0.symbol == card.symbol && $0.quantityOfSymbols == card.quantityOfSymbols}) {
                                Self.cardsOnTheTable.remove(at: index)
                                
                                if let newCard = Self.deck.randomElement(), !Self.cardsOnTheTable.contains(where: {$0 == newCard}) {
                                    Self.cardsOnTheTable.insert(newCard, at: index)
                                }
                            }
                        })
                        findTrueSet_()
                        if selectedCards.isEmpty {
                            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
                        }
                    } else {
                        alert = .itIsNotASet
                    }
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

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

