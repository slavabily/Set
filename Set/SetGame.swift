//
//  SetGame.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import SwiftUI

class SetGame: ObservableObject {
    
    @Published
    var model = Symbol()
    
    @ViewBuilder
    func shape<T: Shape>(_ shape: T) -> some View {
        switch model.look {
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
        switch model.name {
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
        switch model.color {
        case .red:
            symbol.foregroundColor(.red)
        case .blue:
            symbol.foregroundColor(.blue)
        case .green:
            symbol.foregroundColor(.green)
        }
    }
}
