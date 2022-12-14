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
        VStack {
            AspectVGrid(items: setGame.cards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .onTapGesture {
                        setGame.selectCard(card)
                    }
            }
            buttons
            AlertView(showingSetIsRemoved: setGame.showingSetIsRemoved,
                      showingItIsNotSet: setGame.showingItIsNotSet,
                      showingOpen3MoreCards: setGame.showingOpen3MoreCards)
        }
    }
    
    var buttons: some View {
        HStack {
            if setGame.cards.count < 21 {
                Button("Open 3 Cards") {
                    setGame.open3Cards()
                }
            }
            Spacer()
            Button("Find Set") {
                setGame.findTrueSet()
            }
        }
        .font(.title)
        .padding()
    }
}

struct AlertView: View {
    
    let showingSetIsRemoved: Bool
    let showingItIsNotSet: Bool
    let showingOpen3MoreCards: Bool
    
    var body: some View {
        if showingSetIsRemoved {
            Text_(message: "Set is removed!", background: .green)
        } else if showingItIsNotSet {
            Text_(message: "It is not a set!", background: .red)
        } else if showingOpen3MoreCards {
            Text_(message: "There is no set on the board. Open 3 more Cards", background: .blue)
        }
    }
    
    struct Text_: View {
        let message: String
        let background: Color
        
        var body: some View {
            Text(message)
                .padding(.top)
                .frame(maxWidth: .infinity)
                .background(background)
                .foregroundColor(.white)
        }
    }
}

struct CardView: View {
    
    let card: Card
    
    var body: some View {
        GeometryReader { geometry in
            let card = RoundedRectangle(cornerRadius: geometry.size.width/5)
            ZStack { 
                cardBackground(card)
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
            ZStack {
                shape.fill(.white)
                shape.stroke(lineWidth: 5)
            }
        case .shaded:
            shape.opacity(0.5)
        }
    }
    
    @ViewBuilder
    func cardBackground<T: Shape>(_ card: T) -> some View {
        switch self.card.status {
        case .default:
            card
                .fill()
                .foregroundColor(.white)
        case .selected:
            card
                .fill()
                .opacity(0.3)
                .foregroundColor(.yellow)
        case .founded:
            card
                .fill()
                .opacity(0.3)
                .foregroundColor(.pink)
        }
    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGame())
    }
}
