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
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))]) {
            ForEach(0..<setGame.cards.count) { _ in
                CardView(setGame: setGame)
            }
        }
    }
}

struct CardView: View {
    
    let setGame: SetGame
    
    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 20)
        ZStack {
            shape
                .fill()
                .foregroundColor(/*@START_MENU_TOKEN@*/.white/*@END_MENU_TOKEN@*/)
            shape
                .strokeBorder(lineWidth: 3)
            setGame.cardLook
                .scaleEffect(0.8)
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
