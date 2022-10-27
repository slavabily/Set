//
//  Game.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import Foundation

struct Symbol {
    let name: Shape
    let color: Color
    let look: Look
    
    init() {
        name = Shape.allCases.randomElement()!
        color = Color.allCases.randomElement()!
        look = Look.allCases.randomElement()!
    }
    
    enum Shape: CaseIterable {
        case rectangle
        case capsule
        case diamond
    }
    
    enum Color: CaseIterable {
        case red
        case green
        case blue
    }
    
    enum Look: CaseIterable {
        case stroked
        case filled
        case shaded
    }
}
