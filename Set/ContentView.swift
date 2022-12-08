//
//  ContentView.swift
//  Set
//
//  Created by slava bily on 20.10.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var setGame: SetGame
    
    var body: some View {
        AspectVGrid(items: setGame.cards, aspectRatio: 2/3) { card in
            CardView(card: card)
            
        }
    }
}

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        GeometryReader { geometry in
            let card = RoundedRectangle(cornerRadius: geometry.size.width/5)
            ZStack {
                card
                    .fill()
                    .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
                card
                    .strokeBorder(lineWidth: 3)
                VStack {
                    Spacer()
                    cardLook
                    Spacer()
                }
            }
        }
        .aspectRatio(2/3, contentMode: .fill)
        .padding(2)
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
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGame())
    }
}
