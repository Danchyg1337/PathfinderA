import Foundation
import SwiftUI

class CanvasModel: ObservableObject {
    @Published var canvasSize: CGSize = .zero
    @Published var globalOffset: CGSize = .zero
    @Published var globalZoom: CGFloat = 1
    @Published var zoom: CGFloat = 1
    @Published var showNodeValues: Bool = true
    @Published var gridLoading: Bool = false
    
    @Published private(set) var canvasState: CanvasState = .none
    @Published private(set) var canvasMode: CanvasMode = .picking
    @Published private(set) var sidePanelState: SidePanelState = .hidden
    @Published private(set) var tutorialState: TutorialState = .none
    
    enum CanvasState {
        case movingNode(node: Node)
        case connectingNode(node: Node)
        case inspectingNode(node: Node)
        case none
    }
    
    enum CanvasMode {
        case moving
        case picking
    }
    
    enum SidePanelState {
        case grid
        case settings
        case help
        case hidden
    }
    
    enum TutorialState {
        case setNodes
        case moveNodes
        case connectNodes
        case setStartEnd
        case runAlgorithm
        case none
        
        @ViewBuilder
        var view: some View {
            switch self {
            case .setNodes: SetNodeTutorial()
            case .moveNodes: MoveNodeTutorial()
            case .connectNodes: ConnectNodesTutorial()
            case .setStartEnd: SetStartEndTutorial()
            case .runAlgorithm: RunAlgorithmTutorial()
            case .none: EmptyView()
            }
        }
    }
    
    func setState(_ state: CanvasState) {
        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
            canvasState = state
        }
    }
    
    func setMode(_ mode: CanvasMode) {
        withAnimation {
            canvasMode = mode
        }
    }
    
    func setSidePanelState(_ state: SidePanelState) {
        withAnimation {
            sidePanelState = state
        }
    }
    
    func setTutorialState(_ state: TutorialState) {
        withAnimation {
            tutorialState = state
        }
    }
    
    public func getSelectedNode() -> Node? {
        var currentNode: Node?
        switch canvasState {
        case .movingNode(let node), .connectingNode(let node):
            currentNode = node
        default:
            break
        }
        return currentNode
    }
    
    public func getScalingForNode(for node: Node) -> CGFloat {
        if case .movingNode(let currentNode) = canvasState {
            return currentNode == node ? 2 : 1
        }
        return 1
    }
    
    public func getPositionForNode(for node: Node) -> CGSize {
        CGSize(width: node.coordinates.x * globalZoom, height: node.coordinates.y * globalZoom)
    }
    
    public func zoomIn() {
        globalZoom *= 1.25
    }
    
    public func zoomOut() {
        globalZoom /= 1.25
    }
    
    public func move(by offset: CGSize) {
        globalOffset = globalOffset + offset
    }
    
    public func setSize(size: CGSize) {
        canvasSize = size
    }
    
    public func translateToCanvasCoordinates(_ point: CGPoint) -> CGPoint {
        return (point - canvasSize / 2 - globalOffset) / globalZoom
    }
    
    public func translateToViewCoordinates(_ point: CGPoint) -> CGPoint {
        return point * globalZoom + canvasSize / 2 + globalOffset
    }
}
