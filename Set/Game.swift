//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Game {
    private(set) var setIsRemoved = false
    private(set) var itIsNotSet = false
    
    private var allCards = [Card]()
    private(set) static var cardsOnTheTable = [Card]()
    private var trueSet = [Card]()
    private var setToCompare = [Card]()
    private var selectedCards = [Card]()
    
    private var initiallyDealtCards: [Card] {
        deal(from: allCards)
    }
    
    private func deal(from cards: [Card]) -> [Card] {
        var dCards = [Card]()
        repeat {
            let dealtCard = cards.randomElement()
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
        findTrueSet()
        if selectedCards.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        }
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
        findTrueSet()
        if selectedCards.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        }
    }
    
    mutating func findTrueSet() {
        trueSet.removeAll()
        selectedCards.removeAll()
        if selectedCards.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
        }
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
                            if trueSet.isEmpty {
                                trueSet = [card1, card2, card3]
                                trueSet.forEach({ mark($0, with: .founded)})
                            }
                        }
                    }
                }
            }
        }
    }
    
    mutating func selectCard(_ card: Card) {
        if !trueSet.isEmpty {
            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
            setToCompare = trueSet
            trueSet.removeAll()
            return
        }
        setIsRemoved = false
        itIsNotSet = false
        
        if card.status == .default || card.status == .founded {
            
            if selectedCards.count < 3 {
                mark(card, with: .selected)
                selectedCards.append(card)
                
                if !setToCompare.isEmpty, selectedCards.count == setToCompare.count {
                    let difference = setToCompare.difference(from: selectedCards)
                    print("difference: \(difference)")
                    
                    if difference.isEmpty {
                        setToCompare.forEach({ card in
                            allCards.removeAll(where: {$0 == card})
                            
                            if let index = Self.cardsOnTheTable.firstIndex(where: {$0.symbol == card.symbol && $0.quantityOfSymbols == card.quantityOfSymbols}) {
                                Self.cardsOnTheTable.remove(at: index)
                                
                                if let newCard = allCards.randomElement(), !Self.cardsOnTheTable.contains(where: {$0 == newCard}) {
                                    Self.cardsOnTheTable.insert(newCard, at: index)
                                }
                            }
                        })
                        setIsRemoved = true
                        findTrueSet()
                        if selectedCards.isEmpty {
                            Self.cardsOnTheTable.forEach({mark($0, with: .default)})
                        }
                    } else {
                        itIsNotSet = true
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
        case .founded:
            newCard.status = .founded
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
        case founded
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

