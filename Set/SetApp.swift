//
//  SetApp.swift
//  Set
//
//  Created by slava bily on 20.10.2022.
//

import SwiftUI

@main
struct SetApp: App {
    let game = SetGame()
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
