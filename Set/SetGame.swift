//
//  SetGame.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import SwiftUI

class SetGame: ObservableObject {
    
    @Published
    private var card = Card(symbol: Symbol())
    
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
    
    @ViewBuilder
    var symbol: some View {
        switch card.symbol.name {
        case .rectangle:
            shape(Rectangle())
        case .capsule:
           shape(Capsule())
        case .diamond:
              shape(Diamond())
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
        switch card.quantity {
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
