//
//  ContentView.swift
//  Set
//
//  Created by slava bily on 20.10.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CardView()
            
            .aspectRatio(4/2, contentMode: .fit)
            .padding()
    }
}


struct CardView: View {
    
    let shape = "Capsule"
    
    var body: some View {
        
        if shape == "Rectangle" {
            Rectangle()
        } else if shape == "Capsule" {
            Capsule()
        } else if shape == "Diamond" {
            Diamond()
        }
    } 
}












struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
