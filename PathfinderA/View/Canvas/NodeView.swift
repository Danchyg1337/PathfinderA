import SwiftUI

struct NodeView: View {
    let node: Node
    let nodeSize: CGFloat
    let showValues: Bool
    
    public static let defaultNodeSize: CGFloat = 50
    
    enum NodeState {
        case clear
        case locked(color: Color = .black)
        case start
        case goal
    }
    let nodeState: NodeState
    
    var nodeColor: Color {
        if case .locked(let color) = nodeState {
            return color
        }
        return Color.black
    }
    
    var nodeLockView: some View {
        Image(systemName: "lock.fill")
            .font(Font.system(size: nodeSize / 1.5))
            .opacity(0.3)
            .foregroundColor(.gray)
    }
    
    func overlayLetter(_ letter: String) -> some View {
        Text(letter)
            .scaleEffect(4.5)
            .opacity(0.3)
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.white)
            Circle()
                .stroke(lineWidth: 2)
            if showValues {
                VStack {
                    Text("H: " + String(format: "%.2f", node.distanceToGoal))
                    Text("G: " + String(format: "%.2f", node.costFromStart))
                    Text("F: " + String(format: "%.2f", node.FValue))
                }
            }
            switch nodeState {
            case .goal:
                overlayLetter("G")
            case .start:
                overlayLetter("S")
            case .locked:
                nodeLockView
            default:
                do {}
            }
        }
        .font(Font.system(size: nodeSize / 6))
        .frame(width: nodeSize, height: nodeSize)
        .foregroundColor(nodeColor)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: true, nodeState: .clear)
    }
}
