import Foundation

class AlgorithmModel: ObservableObject {
    @Published var openedNodes = [Node]()
    @Published var closedNodes = [Node]()
    @Published var finalPath = [Node]()
    
    @Published private(set) var startNode: Node?
    @Published private(set) var goalNode: Node?
    @Published public var heuristicValue = 1.0
    
    private var aStarCore = AStar(start: nil, end: nil)
    
    let algorithmQueue = DispatchQueue(label: "com.Pathfinder.algorithmQueue")
    var algorithmWorkItem: DispatchWorkItem?
    
    func setStartNode(node: Node) {
        startNode = node
        aStarCore.setStart(node: node)
    }
    
    func setGoalNode(node: Node) {
        goalNode = node
        aStarCore.setGoal(node: node)
    }
    
    func run() {
        reset()
        algorithmWorkItem?.cancel()
        algorithmWorkItem = DispatchWorkItem {
            self.aStarCore.find()
            
            DispatchQueue.main.async {
                self.openedNodes = self.aStarCore.openedNodes
                self.closedNodes = self.aStarCore.closedNodes
                self.finalPath = self.aStarCore.finalPath
            }
        }
        
        algorithmQueue.async(execute: algorithmWorkItem!)
    }
    
    func step() {
        if openedNodes.isEmpty || !finalPath.isEmpty {
            reset()
        }
        algorithmWorkItem?.cancel()
        algorithmWorkItem = DispatchWorkItem {
            self.aStarCore.step()
            
            DispatchQueue.main.async {
                self.openedNodes = self.aStarCore.openedNodes
                self.closedNodes = self.aStarCore.closedNodes
                self.finalPath = self.aStarCore.finalPath
            }
        }
        
        algorithmQueue.async(execute: algorithmWorkItem!)
    }
    
    func reset() {
        algorithmWorkItem?.cancel()
        openedNodes.removeAll()
        closedNodes.removeAll()
        finalPath.removeAll()
        aStarCore.reset()
        aStarCore.heuristicBalance = heuristicValue
    }
}
