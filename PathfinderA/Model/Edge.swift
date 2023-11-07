import Foundation

class Edge {
    var id: UUID
    var leftNode: Node
    var rightNode: Node
    var weight: CGFloat
    
    init(left: Node, right: Node) {
        leftNode = left
        rightNode = right
        weight = Node.getDistance(start: left, end: right)
        id = UUID()
    }
}
