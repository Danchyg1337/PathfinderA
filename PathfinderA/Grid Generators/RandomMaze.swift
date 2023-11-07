import Foundation

func gridToMaze(_ grid: inout [Node], start: Node) {
    var currentNode = start.leaves.randomElement()
    start.visited = true
    var parentStack: [Node] = [start]
    var visitedNodes = 1
    while visitedNodes != grid.count {
        guard let currentNodeUW = currentNode else {
            print("End of route")
            return
        }
        var possibleRoutes = [Node]()
        currentNodeUW.leaves.forEach { node in
            if let lastParent = parentStack.last, node == lastParent {
                return
            }
            if node.visited {
                currentNodeUW.leaves.removeAll(where: { $0 == node })
                node.leaves.removeAll(where: { $0 == currentNodeUW })
            }
            else {
                possibleRoutes.append(node)
            }
        }
        visitedNodes += 1
        currentNodeUW.visited = true
        var nextNode = possibleRoutes.randomElement()
        if let nextNode = nextNode {
            parentStack.append(currentNodeUW)
            currentNode = nextNode
        }
        else {
            while !parentStack.isEmpty {
                guard let lastParent = parentStack.last else {
                    return
                }
                nextNode = lastParent.leaves.filter( { !$0.visited } ).randomElement()
                if nextNode != nil {
                    currentNode = nextNode
                    break
                }
                else {
                    parentStack.removeLast()
                }
            }
            if parentStack.isEmpty {
                return
            }
        }
    }
}
