import SwiftUI

struct MovableCanvas: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @GestureState private var dragOffset: CGSize = .zero
    
    var sidePanelOpened: Bool {
        canvasData.sidePanelState != .hidden
    }
    
    var body: some View {
        GeometryReader { reader in
            ZStack {
                Rectangle()
                    .fill(Color(.white))
                    .overlay {
                        CanvasContent()
                            .environmentObject(contentData)
                            .environmentObject(canvasData)
                            .offset(canvasData.globalOffset + dragOffset)
                    }
                    .highPriorityGesture(canvasData.canvasMode == .moving ? drag : nil)
                    .gesture(canvasData.canvasMode == .picking ? drag : nil)
                    .gesture(doubleTap)
                    .onAppear {
                        canvasData.setSize(size: reader.size)
                    }
                    .coordinateSpace(name: "canvas")
                    .disabled(sidePanelOpened)
                
                if sidePanelOpened {
                    Rectangle()
                        .fill(Color.white)
                        .opacity(0.001)
                        .highPriorityGesture(tap)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

struct MovableCanvas_Previews: PreviewProvider {
    static var previews: some View {
        MovableCanvas()
            .environmentObject(ContentModel())
            .environmentObject(AlgorithmModel())
            .environmentObject(CanvasModel())
    }
}

//Gestures
extension MovableCanvas {
    
    var drag: some Gesture {
        DragGesture()
            .updating($dragOffset) { value, state, _ in
                state = value.translation
            }
            .onEnded { value in
                canvasData.move(by: value.translation)
            }
    }
    
    var doubleTap: some Gesture {
        SpatialTapGesture(count: 2)
            .onEnded { event in
                contentData.addNode(at: canvasData.translateToCanvasCoordinates(event.location))
            }
    }
    
    var tap: some Gesture {
        SpatialTapGesture(count: 1)
            .onEnded { event in
                canvasData.setSidePanelState(.hidden)
            }
    }
    
    var zoom: some Gesture {
        MagnificationGesture()
            .onChanged { event in
                
            }
            .onEnded { event in
                
            }
    }
}
