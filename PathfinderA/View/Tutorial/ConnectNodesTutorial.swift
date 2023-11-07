import SwiftUI

struct ConnectNodesTutorial: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    @State var playAnimation = false
    
    let text = "Drag to connect two nodes together"
    static let firstNodePosition = CGSize(width: 75, height: -50)
    static let secondNodePosition = CGSize(width: -65, height: 50)
    static let pointerOffset = CGSize(width: 35, height: 50)
    
    private struct AnimationValues {
        var scale = 1.0
        var offset = firstNodePosition + pointerOffset
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Image(systemName: "hand.point.up.left.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 100)
                        .shadow(radius: 10, x: 5, y: 5)
                        .keyframeAnimator(
                            initialValue: AnimationValues(),
                            trigger: playAnimation
                        ) { content, value in
                            ZStack {
                                EdgeView(start: CGPoint(x: ConnectNodesTutorial.firstNodePosition.width + geometry.size.width / 2,
                                                        y: ConnectNodesTutorial.firstNodePosition.height + geometry.size.height / 2),
                                         end: CGPoint(x: geometry.size.width / 2 + value.offset.width - ConnectNodesTutorial.pointerOffset.width,
                                                      y: geometry.size.height / 2 + value.offset.height - ConnectNodesTutorial.pointerOffset.height + (1.0 - value.scale) * 100), globalZoom: 1)
                                NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false, nodeState: .clear)
                                    .offset(ConnectNodesTutorial.firstNodePosition)
                                NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false, nodeState: .clear)
                                    .offset(ConnectNodesTutorial.secondNodePosition)
                                content
                                    .scaleEffect(value.scale)
                                    .offset(value.offset)
                            }
                        } keyframes: { _ in
                            KeyframeTrack(\.scale) {
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(0.9, duration: 2.15)
                                LinearKeyframe(1.0, duration: 0.15)
                            }
                            
                            KeyframeTrack(\.offset) {
                                LinearKeyframe(ConnectNodesTutorial.firstNodePosition + ConnectNodesTutorial.pointerOffset, duration: 1.5)
                                CubicKeyframe(CGSize(width: 0, height: 0), duration: 1.0)
                                CubicKeyframe(ConnectNodesTutorial.secondNodePosition + ConnectNodesTutorial.pointerOffset, duration: 1.0)
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
            HStack {
                Text(text)
                NextButton {
                    canvasData.setTutorialState(CanvasModel.TutorialState.setStartEnd)
                }
            }
            .padding()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
                playAnimation.toggle()
            }
            .fire()
        }
    }
}

#Preview {
    ConnectNodesTutorial()
        .environmentObject(ContentModel())
        .environmentObject(AlgorithmModel())
}
