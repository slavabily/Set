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
            let card = Card(symbol: Card.Symbol())
            cards.append(card)
        }
    }
    
    struct Card {
        let symbol: Symbol
        let quantityOfSymbols = (1...3).randomElement()
        
        struct Symbol {
            let shape: Shape
             
            init() {
                shape = .allCases.randomElement()!
            }
             
            enum Shape: CaseIterable {
                static var allCases: [Game.Card.Symbol.Shape] = [
                    .rectangle(.blue, .shaded), .rectangle(.red, .shaded), .rectangle(.green, .shaded),
                    .rectangle(.blue, .stroked), .rectangle(.red, .stroked), .rectangle(.green, .stroked),
                    .rectangle(.blue, .filled), .rectangle(.red, .filled), .rectangle(.green, .filled),
                    
                    .capsule(.blue, .shaded), .capsule(.red, .shaded), .capsule(.green, .shaded),
                    .capsule(.blue, .stroked), .capsule(.red, .stroked), .capsule(.green, .stroked),
                    .capsule(.blue, .filled), .capsule(.red, .filled), .capsule(.green, .filled),
                    
                    .diamond(.blue, .shaded), .diamond(.red, .shaded), .diamond(.green, .shaded),
                    .diamond(.blue, .stroked), .diamond(.red, .stroked), .diamond(.green, .stroked),
                    .diamond(.blue, .filled), .diamond(.red, .filled), .diamond(.green, .filled)
                ]
                
                case rectangle(Color, Look)
                case capsule(Color, Look)
                case diamond(Color, Look)
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
    }
}



