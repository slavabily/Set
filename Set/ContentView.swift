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
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {
                ForEach(0..<setGame.cards.count) { _ in
                    CardView(card: setGame)
                }
            }
        }
    }
}

struct CardView: View {
    
    let card: SetGame
    
    var body: some View {
        let card = RoundedRectangle(cornerRadius: 20)
        ZStack {
            card
                .fill()
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            card
                .strokeBorder(lineWidth: 3)
            VStack {
                Spacer()
                self.card.cardLook
                Spacer()
            }
            
        }
        .aspectRatio(2/3, contentMode: .fit)
        .padding()    
    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(setGame: SetGame())
    }
}
