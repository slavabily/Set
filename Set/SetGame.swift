//
//  SetGame.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import SwiftUI

class SetGame: ObservableObject {
    
    private static func createGame() -> Game {
        return Game()
    }
    
    @Published
    private var game: Game = createGame()
    
    var cards: [Card] {
        Game.cardsOnTheTable
    }
    
    var showingSetIsRemoved: Bool {
        game.isSetRemoved
    }
    
    // MARK: Actions
    
    func open3Cards() {
        game.open3Cards()
    }
    
    func selectCard(_ card: Card) {
        game.selectCard(card)
    }
    
    func findTrueSet() {
        game.findTrueSet()
    }
}
