//
//  Diamond.swift
//  Set
//
//  Created by slava bily on 21.10.2022.
//

import SwiftUI

struct Diamond: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        let up = CGPoint(x: rect.midX, y: rect.maxY)
        let down = CGPoint(x: rect.midX, y: rect.minY)
        let left = CGPoint(x: rect.minX, y: rect.midY)
        let right = CGPoint(x: rect.maxX, y: rect.midY)
        
        var p = Path()
        p.move(to: up)
        p.addLine(to: left)
        p.addLine(to: down)
        p.addLine(to: right)
        p.addLine(to: up)
        
         return p
    }
}
