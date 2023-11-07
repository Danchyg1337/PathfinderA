import SwiftUI

struct EdgeView: View {
    let start: CGPoint
    let end: CGPoint
    let globalZoom: CGFloat
    
    var body: some View {
        Path() { path in
            path.move(to: start)
            path.addLine(to: end)
        }
        .stroke(lineWidth: 3 * globalZoom)
        .fill(Color.black)
    }
}

#Preview {
    EdgeView(start: CGPoint(), end: CGPoint(), globalZoom: 1)
}
