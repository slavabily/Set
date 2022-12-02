//
//  SetGame.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import SwiftUI

class SetGame: ObservableObject {
    
    static func createGame() -> Game {
        return Game(quantityOfCards: 81)
    }
    
    @Published
    private var game: Game = createGame()
    
    var cards: [Card] {
        game.cards
    }
    
    var card: Card {
        cards.randomElement()!
    }
    
    // MARK: UI
    
    func aspect<T: View>(_ s: T) -> some View {
        return s
            .aspectRatio(4/2, contentMode: .fit)
            .scaleEffect(0.8)
    }
    
    @ViewBuilder
    func shape<T: Shape>(_ shape: T) -> some View {
        switch card.symbol.look {
        case .filled:
            shape
        case .stroked:
            shape.stroke(lineWidth: 5)
        case .shaded:
            shape.opacity(0.5)
        }
    }
    
    @ViewBuilder
    var symbol: some View {
        switch card.symbol.shape {
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
            let coloredSymbol = coloredSymbol
            switch card.quantityOfSymbols {
            case 1:
                VStack{
                    coloredSymbol
                }
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
