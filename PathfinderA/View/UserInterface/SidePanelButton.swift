//
//  SidePanelButton.swift
//  MapWalker
//
//  Created by Denis on 22/8/23.
//

import SwiftUI

struct SidePanelButton: View {
    var imageName: String
    var text: String
    var action: () -> Void
    var body: some View {
        HStack {
            if !imageName.isEmpty {
                Image(systemName: imageName)
                    .font(Font.system(size: 28))
            }
            Text(text)
                .modifier(SidePanelTextModifier())
        }
        .padding(5)
        .onTapGesture {
            action()
        }
        
    }
}

struct SidePanelTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.system(size: 15))
            .foregroundColor(.black)
            .multilineTextAlignment(.leading)
            .padding(5)
    }
}

struct SidePanelButton_Previews: PreviewProvider {
    static var previews: some View {
        SidePanelButton(imageName: "circle.grid.2x2", text: "Small Grid") {}
    }
}
