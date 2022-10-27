//
//  ContentView.swift
//  Set
//
//  Created by slava bily on 20.10.2022.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetGame
    
    var body: some View {
        CardView(game: game)
            .aspectRatio(4/2, contentMode: .fit)
            .padding()
    }
}

struct CardView: View {
    
    let game: SetGame
    
    var body: some View {
        ZStack {
            game.coloredSymbol
        }
        
        
        
        
    }
}













struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGame())
    }
}
