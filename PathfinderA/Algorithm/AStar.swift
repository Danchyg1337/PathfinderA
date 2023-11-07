import Foundation

class AStar {
    private(set) var start: Node?
    private(set) var goal: Node?
    var finalPath = [Node]()
    
    var closedNodes = [Node]()
    var openedNodes = [Node]()
    
    var heuristicBalance = 1.0
    
    private func heuristic(distance: CGFloat, cost: CGFloat) -> CGFloat {
        return distance * (2.0 - heuristicBalance) + cost * heuristicBalance
    }
    
    init(start: Node?, end: Node?) {
        guard let start = start, let end = end else {
            print("Empty start/end node passed to init()")
            return
        }
        setStart(node: start)
        setGoal(node: end)
    }
    
    func setOpened(nodes: inout [Node]) {
        self.openedNodes = nodes
    }
    
    func setStart(node: Node) {
        self.start = node
        setup()
    }
    
    func setGoal(node: Node) {
        self.goal = node
        setup()
    }
    
    func setup() {
        if let start = self.start, let goal = self.goal {
            start.distanceToGoal = Node.getDistance(start: start, end: goal)
            openedNodes.removeAll()
            openedNodes.append(start)
        }
    }
    
    public func find() {
        if start == nil || goal == nil {
            print("Start or goal node is not set")
            return
        }
        while !openedNodes.isEmpty && finalPath.isEmpty {
            step()
        }
        if openedNodes.isEmpty {
            print("Couldn't find the end")
            return
        }
    }
    
    public func step() {
        guard let goal = self.goal else {
            print("Goal node is not set")
            return
        }
        guard let currentNode = openedNodes.min(by: { $0.FValue < $1.FValue }) else {
            print("There are no opened nodes")
            return
        }
        if currentNode == goal {
            print("The goal has been reached")
            fillFinalPath(node: goal)
            finalPath.reverse()
            return
        }
        closedNodes.append(currentNode)
        if let currentNodeIndex = openedNodes.firstIndex(where: { $0 == currentNode }) {
            openedNodes.remove(at: currentNodeIndex)
        }
        
        for inspectingNode in currentNode.leaves {
            let isInOpenedList = openedNodes.contains { $0 == inspectingNode}
            let isInClosedList = closedNodes.contains { $0 == inspectingNode}
            
            let GValue = currentNode.costFromStart + Node.getDistance(start: currentNode, end: inspectingNode)
            let HValue = Node.getDistance(start: inspectingNode, end: goal)
            let FValue = heuristic(distance: HValue, cost: GValue)
            
            if !isInClosedList && !isInOpenedList {
                inspectingNode.costFromStart = GValue
                inspectingNode.distanceToGoal = HValue
                inspectingNode.FValue = FValue
                inspectingNode.parent = currentNode
                openedNodes.append(inspectingNode)
                continue
            }
            
            if isInOpenedList && inspectingNode.costFromStart > GValue {
                inspectingNode.costFromStart = GValue
                inspectingNode.parent = currentNode
            }
            
            if isInClosedList && inspectingNode.costFromStart > GValue {
                inspectingNode.costFromStart = GValue
                inspectingNode.parent = currentNode
            }
        }
    }
    
    public func reset() {
        openedNodes.removeAll()
        closedNodes.removeAll()
        finalPath.removeAll()
        setup()
    }
    
    private func fillFinalPath(node: Node) {
        finalPath.append(node)
        if let parent = node.parent {
            fillFinalPath(node: parent)
        }
    }
}
