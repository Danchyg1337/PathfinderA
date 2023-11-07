import SwiftUI

struct MoveNodeTutorial: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    @State var playAnimation = false
    
    let text = "Hold on a node to move it around"
    static let nodePosition = CGSize(width: 75, height: -50)
    static let pointerOffset = CGSize(width: 35, height: 50)
    
    private struct AnimationValues {
        var pointerScale = 1.0
        var nodeScale = 1.0
        var offset = nodePosition + pointerOffset
    }
    
    var body: some View {
        VStack {
            ZStack {
                Image(systemName: "hand.point.up.left.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .keyframeAnimator(
                        initialValue: AnimationValues(),
                        trigger: playAnimation
                    ) { content, value in
                        ZStack {
                            NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: true, nodeState: .clear)
                                .scaleEffect(value.nodeScale)
                                .offset(value.offset - MoveNodeTutorial.pointerOffset)
                            content
                                .scaleEffect(value.pointerScale)
                                .offset(value.offset)
                        }
                    } keyframes: { _ in
                        KeyframeTrack(\.pointerScale) {
                            LinearKeyframe(1.0, duration: 1.0)
                            LinearKeyframe(0.9, duration: 0.15)
                            LinearKeyframe(0.9, duration: 4.0)
                            LinearKeyframe(1.0, duration: 0.15)
                            LinearKeyframe(1.0, duration: 2.0)
                        }
                        
                        KeyframeTrack(\.nodeScale) {
                            LinearKeyframe(1.0, duration: 2.0)
                            LinearKeyframe(2.0, duration: 0.15)
                            LinearKeyframe(2.0, duration: 3.0)
                            LinearKeyframe(1.0, duration: 0.15)
                            LinearKeyframe(1.0, duration: 1.15)
                        }
                        
                        KeyframeTrack(\.offset) {
                            LinearKeyframe(MoveNodeTutorial.nodePosition + MoveNodeTutorial.pointerOffset, duration: 3.0)
                            LinearKeyframe(CGSize(width: -80, height: 100), duration: 2.0)
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            HStack {
                Text(text)
                NextButton {
                    canvasData.setTutorialState(CanvasModel.TutorialState.connectNodes)
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
    MoveNodeTutorial()
        .environmentObject(ContentModel())
        .environmentObject(AlgorithmModel())
}
