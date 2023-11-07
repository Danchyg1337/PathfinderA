//
//  CanvasButton.swift
//  MapWalker
//
//  Created by Denis on 21/8/23.
//

import SwiftUI

struct CanvasButton: View {
    var iconName: String
    var action: () -> Void
    
    static var color = Color("ButtonSetColor")
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .opacity(0.2)
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .padding(.all, 4)
        }
        .frame(width: 30, height: 30)
        .transition(.move(edge: .trailing))
        .onTapGesture {
            action()
        }
    }
}

struct CanvasButton_Previews: PreviewProvider {
    static var previews: some View {
        CanvasButton(iconName: "skew") {
            
        }
    }
}
