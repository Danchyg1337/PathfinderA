import SwiftUI

struct ContentView: View {
    @State private var contentData = ContentModel()
    @ObservedObject private var canvasData = CanvasModel()
    @State var algorithmData = AlgorithmModel()
    
    var showNodeSettings: Bool {
        if case .inspectingNode(_) = canvasData.canvasState {
            return true
        }
        return false
    }
    
    var body: some View {
        ZStack {
            if canvasData.tutorialState != .none {
                canvasData.tutorialState.view
            }
            else {
                ZStack(alignment: .topLeading) {
                    MovableCanvas()
                    HStack(alignment: .top) {
                        if canvasData.sidePanelState != .hidden {
                            SidePanel()
                                .frame(width: canvasData.canvasSize.width * 0.6, alignment: .leading)
                                .transition(.move(edge: .leading))
                        }
                        CanvasButtonSet()
                            .padding()
                    }
                }
                
                if showNodeSettings {
                    BlurredOverlay()
                }
            }
        }
        .highPriorityGesture(showNodeSettings ? tap : nil)
        .overlay {
            if case .inspectingNode(let node) = canvasData.canvasState {
                NodeSettings(node: node)
            }
        }
        .environmentObject(canvasData)
        .environmentObject(contentData)
        .environmentObject(algorithmData)
    }
}

extension ContentView {
    var tap: some Gesture {
        SpatialTapGesture(count: 1)
            .onEnded { event in
                canvasData.setState(.none)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
