import SwiftUI

struct SetNodeTutorial: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    @State var playAnimation = false
    @State var showFirstNode = false
    @State var showSecondNode = false
    
    let text = "Double tapping will create a new node"
    static let firstNodePosition = CGSize(width: 75, height: -50)
    static let secondNodePosition = CGSize(width: -65, height: 50)
    static let pointerOffset = CGSize(width: 35, height: 50)
    
    private struct AnimationValues {
        var scale = 1.0
        var offset = firstNodePosition + pointerOffset
    }
    
    var body: some View {
        VStack {
            ZStack {
                if showFirstNode {
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: true, nodeState: .clear)
                        .offset(SetNodeTutorial.firstNodePosition)
                }
                if showSecondNode {
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: true, nodeState: .clear)
                        .offset(SetNodeTutorial.secondNodePosition)
                }
                Image(systemName: "hand.point.up.left.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 100)
                    .keyframeAnimator(
                        initialValue: AnimationValues(),
                        trigger: playAnimation
                    ) { content, value in
                        content
                            .scaleEffect(value.scale)
                            .offset(value.offset)
                    } keyframes: { _ in
                        KeyframeTrack(\.scale) {
                            LinearKeyframe(1.0, duration: 1.0)
                            LinearKeyframe(0.9, duration: 0.15)
                            LinearKeyframe(1.0, duration: 0.15)
                            LinearKeyframe(0.9, duration: 0.15)
                            LinearKeyframe(1.0, duration: 0.15)
                            LinearKeyframe(1.0, duration: 2.0)
                            LinearKeyframe(0.9, duration: 0.15)
                            LinearKeyframe(1.0, duration: 0.15)
                            LinearKeyframe(0.9, duration: 0.15)
                            LinearKeyframe(1.0, duration: 0.15)
                        }
                        
                        KeyframeTrack(\.offset) {
                            LinearKeyframe(SetNodeTutorial.firstNodePosition + SetNodeTutorial.pointerOffset, duration: 2.0)
                            SpringKeyframe(SetNodeTutorial.secondNodePosition + SetNodeTutorial.pointerOffset, duration: 2.0, spring: Spring(duration: 0.7, bounce: 0.15))
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Spacer()
            HStack {
                Text(text)
                NextButton {
                    canvasData.setTutorialState(CanvasModel.TutorialState.moveNodes)
                }
            }
            .padding()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 8.0, repeats: true) { _ in
                playAnimation.toggle()
                showSecondNode = false
                showFirstNode = false
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                    showFirstNode = true
                }
                Timer.scheduledTimer(withTimeInterval: 4.2, repeats: false) { _ in
                    withAnimation {
                        showSecondNode = true
                    }
                }
            }
            .fire()
        }
    }
}

struct SetNodeTutorial_Previews: PreviewProvider {
    static var previews: some View {
        SetNodeTutorial()
            .environmentObject(ContentModel())
            .environmentObject(AlgorithmModel())
    }
}
