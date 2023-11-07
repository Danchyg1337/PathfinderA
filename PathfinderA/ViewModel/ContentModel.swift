import Foundation

class ContentModel: ObservableObject {
    @Published private(set) var nodes = [Node]()
    @Published private(set) var edges = [Edge]()
    
    public func reload() {
        self.nodes.removeAll()
        self.edges.removeAll()
    }
    
    public func setNodes(nodes: [Node]) {
        self.nodes.removeAll()
        self.nodes = nodes
    }
    
    public func addNode(at point: CGPoint) {
        nodes.append(Node(at: point))
    }
    
    public func removeNode(node: Node) {
        if let nodeIndexToRemove = nodes.firstIndex(where: {$0 == node}) {
            for leaf in node.leaves {
                leaf.leaves.removeAll(where: { $0 == node })
            }
            nodes.remove(at: nodeIndexToRemove)
        }
        edges.removeAll(where: { $0.leftNode == node || $0.rightNode == node })
    }
    
    public func moveNode(node: Node, to point: CGPoint) {
        node.coordinates = point
    }
    
    public func reloadEdges() {
        edges.removeAll()
        var discoveredNodes = [Node]()
        for node in nodes {
            if discoveredNodes.contains(where: { $0 == node }) {
                continue
            }
            for leaf in node.leaves {
                if discoveredNodes.contains(where: { $0 == leaf }) {
                    continue
                }
                edges.append(Edge(left: node, right: leaf))
            }
            discoveredNodes.append(node)
        }
    }
    
    public func connectNodes(start: CGPoint, end: CGPoint, nodeSize: CGFloat) {
        let startNode = findNode(at: start, size: nodeSize)
        let endNode = findNode(at: end, size: nodeSize)
        if startNode == nil || endNode == nil {
            print("Error connecting nodes")
            return
        }
        if startNode!.leaves.contains(where: {$0 == endNode!}) {
            disconnectNodes(start: startNode!, end: endNode!)
            return
        }
        connectNodes(start: startNode!, end: endNode!)
    }
    
    public func connectNodes(start: Node, end: Node) {
        edges.append(Edge(left: start, right: end))
        start.leaves.append(end)
        end.leaves.append(start)
    }
    
    public func disconnectNodes(start: Node, end: Node) {
        if let edgeIndexToRemove = edges.firstIndex(where: {($0.leftNode == start && $0.rightNode == end)
                                                    || $0.rightNode == start && $0.leftNode == end}) {
            edges.remove(at: edgeIndexToRemove)
        }
        if let startNodeIndexToRemove = start.leaves.firstIndex(where: {$0 == end}) {
            start.leaves.remove(at: startNodeIndexToRemove)
        }
        if let endNodeIndexToRemove = end.leaves.firstIndex(where: {$0 == start}) {
            end.leaves.remove(at: endNodeIndexToRemove)
        }
    }
    
    //at point: should be translated in advance relative to the centre of the view using translateToCanvasCoordinates()
    public func findNode(at point: CGPoint, size: CGFloat) -> Node? {
        return nodes.first(where: { node in
            return (abs(point.x - node.coordinates.x) < size / 2) && (abs(point.y - node.coordinates.y) < size / 2)
        })
    }
}
