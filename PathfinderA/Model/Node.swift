import Foundation

class Node {
    var id: UUID
    var coordinates: CGPoint
    
    var leaves = [Node]()

    var costFromStart: CGFloat = 0
    var distanceToGoal: CGFloat = 0
    var FValue: CGFloat = 0
    
    //used to determine the final path
    var parent: Node?
    
    //used for maze generation
    var visited: Bool = false
    
    init(at coordinates: CGPoint) {
        self.coordinates = coordinates
        self.id = UUID()
    }
    
    func setGHFValue(fromStart: CGFloat, toGoal: CGFloat) {
        costFromStart = fromStart
        distanceToGoal = toGoal
        FValue = costFromStart + distanceToGoal
    }
    
    static func getDistance(start: Node, end: Node) -> CGFloat {
        let sub = start.coordinates - end.coordinates
        return CGFloat(sqrt(sub.x * sub.x + sub.y * sub.y))
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.coordinates == rhs.coordinates
    }
}
