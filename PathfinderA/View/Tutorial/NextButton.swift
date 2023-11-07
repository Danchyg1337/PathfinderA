import SwiftUI

struct NextButton: View {
    var action: () -> Void
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 80, height: 40)
                .opacity(0.2)
            HStack {
                Text("Next")
                Image(systemName: "arrowshape.right.fill")
            }
        }
        .foregroundColor(CanvasButton.color)
        .onTapGesture {
            action()
        }
    }
}

struct NextButton_Previews: PreviewProvider {
    static var previews: some View {
        NextButton(action: {})
    }
}
