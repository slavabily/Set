//
//  SetGame.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import SwiftUI

class SetGame: ObservableObject {
    
    static func createGame() -> Game {
        return Game(quantityOfCards: 4)
    }
   
   @Published
    private var game: Game = createGame()
    
    var cards: [Game.Card] {
        game.cards
    }
    
    var card: Game.Card {
        cards.randomElement()!
    }
     
    @ViewBuilder
    func shape<T: Shape>(_ shape: T) -> some View {
        switch card.symbol.look {
        case .filled:
            shape
        case .shaded:
            shape.opacity(0.5)
        case .stroked:
            shape.stroke(lineWidth: 5)
        }
    }
    
    func aspect<T: View>(_ s: T) -> some View {
        return s
            .aspectRatio(4/2, contentMode: .fit)
            .padding()
    }
    
    @ViewBuilder
    var symbol: some View {
        switch card.symbol.name {
        case .rectangle:
            aspect(shape(Rectangle()))
        case .capsule:
            aspect(shape(Capsule()))
        case .diamond:
            aspect(shape(Diamond()))
        }
    }
    
    @ViewBuilder
    var coloredSymbol: some View {
        switch card.symbol.color {
        case .red:
            symbol.foregroundColor(.red)
        case .blue:
            symbol.foregroundColor(.blue)
        case .green:
            symbol.foregroundColor(.green)
        }
    }
    
    @ViewBuilder
    var cardLook: some View {
        switch card.quantityOfSymbols {
        case 1:
               coloredSymbol
        case 2:
            VStack {
                coloredSymbol
                coloredSymbol
            }
        case 3:
            VStack {
                coloredSymbol
                coloredSymbol
                coloredSymbol
            }
        default:
            coloredSymbol
        }
    }
}
