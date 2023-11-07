import SwiftUI

struct CanvasContent: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    
    @State var isDragging = false
    @State var dragStart: CGPoint = .zero
    @GestureState private var dragOffset: CGSize = .zero
    
    var nodeViewSize: CGFloat {
        NodeView.defaultNodeSize * canvasData.globalZoom
    }
    
    var dragStartOnCanvas: CGPoint {
        canvasData.translateToCanvasCoordinates(dragStart)
    }
    
    var body: some View {
        ZStack {
            if case .connectingNode(let node) = canvasData.canvasState {
                let pointOnView = canvasData.translateToViewCoordinates(node.coordinates)
                EdgeView(start: pointOnView - canvasData.globalOffset,
                         end: dragStart - canvasData.globalOffset + dragOffset, globalZoom: canvasData.globalZoom)
            }
            ForEach(contentData.edges, id: \.id) { edge in
                let leftOnView = canvasData.translateToViewCoordinates(edge.leftNode.coordinates)
                let rightOnView = canvasData.translateToViewCoordinates(edge.rightNode.coordinates)
                EdgeView(start: leftOnView - canvasData.globalOffset,
                         end: rightOnView - canvasData.globalOffset, globalZoom: canvasData.globalZoom)
            }
            ForEach(contentData.nodes, id: \.id) { node in
                let nodeState: NodeView.NodeState = {
                    if algorithmData.finalPath.contains(where: {$0 == node} ){
                        return .locked(color: .purple)
                    } else if algorithmData.openedNodes.contains(where: {$0 == node} ){
                        return .locked(color: .green)
                    } else if algorithmData.closedNodes.contains(where: {$0 == node} ){
                        return .locked(color: .red)
                    } else if let goalNode = algorithmData.goalNode, goalNode == node {
                        return .goal
                    } else if let startNode = algorithmData.startNode, startNode == node {
                        return .start
                    } else {
                        return .clear
                    }
                }()
                let gesturesAvailable: Bool = {
                    if case NodeView.NodeState.locked(_) = nodeState {
                        return false
                    }
                    return true
                }()
                let glowColor: Color = {
                    if case NodeView.NodeState.locked(let color) = nodeState {
                        return color
                    }
                    return .black
                }()
                ShadowView(color: glowColor) {
                    NodeView(node: node, nodeSize: nodeViewSize,
                             showValues: canvasData.showNodeValues, nodeState: nodeState)
                        .highPriorityGesture(gesturesAvailable ? tap : nil)
                        .simultaneousGesture(gesturesAvailable ? longPress : nil)
                        .simultaneousGesture(drag)
                        .scaleEffect(canvasData.getScalingForNode(for: node))
                }
                .offset(canvasData.getPositionForNode(for: node))
            }
        }
        .disabled(canvasData.sidePanelState != .hidden)
    }
}

struct CanvasContent_Previews: PreviewProvider {
    static var previews: some View {
        CanvasContent()
            .environmentObject(ContentModel())
            .environmentObject(AlgorithmModel())
            .environmentObject(CanvasModel())
    }
}

//Gestures
extension CanvasContent {
    
    var drag: some Gesture {
        DragGesture(minimumDistance: 0, coordinateSpace: .named("canvas"))
            .updating(self.$dragOffset) { value, state, _ in
                state = value.translation
                if case .movingNode(let node) = canvasData.canvasState {
                    let pointOnCanvas = canvasData.translateToCanvasCoordinates(value.location)
                    contentData.moveNode(node: node, to: pointOnCanvas)
                }
            }
            .onChanged { value in
                dragStart = value.startLocation
                switch canvasData.canvasState {
                case .none:
                    guard let foundNode = contentData.findNode(at: dragStartOnCanvas, size: nodeViewSize) else {
                        print("DRAG: Can't find the node")
                        break
                    }
                    canvasData.setState(.connectingNode(node: foundNode))
                default:
                    break
                }
            }
            .onEnded { value in
                let startPointOnCanvas = canvasData.translateToCanvasCoordinates(dragStart)
                let endPointOnCanvas = canvasData.translateToCanvasCoordinates(dragStart + value.translation)
                contentData.connectNodes(start: startPointOnCanvas,
                                         end: endPointOnCanvas,
                                         nodeSize: nodeViewSize)
                switch canvasData.canvasState {
                case .connectingNode(_), .movingNode(_):
                    canvasData.setState(.none)
                default:
                    break
                }
            }
    }
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 1)
            .onEnded { isPressing in
                switch canvasData.canvasState {
                case .none:
                    guard let foundNode = contentData.findNode(at: dragStartOnCanvas, size: nodeViewSize) else {
                        print("Can't find the node")
                        break
                    }
                    canvasData.setState(.movingNode(node: foundNode))
                case .connectingNode(let node):
                    canvasData.setState(.movingNode(node: node))
                default:
                    break
                }
            }
    }
    
    //at the moment i was writing this function, my friend was getting beaten by his brother for not getting to sleep at a reasonable time (it was terrifying)
    var tap: some Gesture {
        SpatialTapGesture(count: 1)
            .onEnded {state in
                guard let foundNode = contentData.findNode(at: dragStartOnCanvas, size: nodeViewSize) else {
                    print("TAP: Can't find the node")
                    return
                }
                switch canvasData.canvasState {
                case .inspectingNode(_):
                    canvasData.setState(.none)
                default:
                    canvasData.setState(.inspectingNode(node: foundNode))
                }
            }
    }
}

struct ShadowView<Content: View>: View {
    let content: Content
    let color: Color
    init(color: Color, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.color = color
    }
    
    var body: some View {
        content
            .background(
                    Circle()
                        .fill(.black)
                        .shadow(color: color, radius: 5)
            )
    }
}
