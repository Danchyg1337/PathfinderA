//
//  SetStartEndTutorial.swift
//  MapWalker
//
//  Created by Denis on 16/10/23.
//

import SwiftUI

struct SetStartEndTutorial: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    @State var playAnimation = false
    @State var showOverlay = false
    @State var startSet = false
    @State var endSet = false
    
    let text = "Set start and goal nodes before running the algorithm"
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
                    EdgeView(start: CGPoint(x: SetStartEndTutorial.firstNodePosition.width + geometry.size.width / 2,
                                            y: SetStartEndTutorial.firstNodePosition.height + geometry.size.height / 2),
                             end: CGPoint(x: ConnectNodesTutorial.secondNodePosition.width + geometry.size.width / 2,
                                          y: ConnectNodesTutorial.secondNodePosition.height + geometry.size.height / 2), globalZoom: 1)
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false, nodeState: startSet ? .start : .clear)
                        .offset(SetStartEndTutorial.firstNodePosition)
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false,
                             nodeState: endSet ? .goal : .clear)
                    .offset(SetStartEndTutorial.secondNodePosition)
                    
                    if showOverlay {
                        ZStack {
                            BlurredOverlay()
                                .scaleEffect(1.5)
                            NodeSettings(node: Node(at: CGPoint(x: startSet ? -65 : 75,
                                                                y: startSet ? 10 : -80)))
                        }
                    }
                    
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
                                content
                                    .scaleEffect(value.scale)
                                    .offset(value.offset)
                            }
                        } keyframes: { _ in
                            KeyframeTrack(\.scale) {
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(1.0, duration: 1.15)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                            }
                            
                            KeyframeTrack(\.offset) {
                                LinearKeyframe(SetStartEndTutorial.firstNodePosition + SetStartEndTutorial.pointerOffset, duration: 1.5)
                                LinearKeyframe(CGSize(width: 80, height: -140), duration: 1.5)
                                LinearKeyframe(CGSize(width: 80, height: -140), duration: 1.5)
                                LinearKeyframe(SetStartEndTutorial.secondNodePosition + SetStartEndTutorial.pointerOffset, duration: 1.5)
                                LinearKeyframe(SetStartEndTutorial.secondNodePosition + SetStartEndTutorial.pointerOffset, duration: 1.5)
                                LinearKeyframe(CGSize(width: 0, height: -30), duration: 1.5)
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
            HStack {
                Text(text)
                NextButton {
                    canvasData.setTutorialState(CanvasModel.TutorialState.runAlgorithm)
                }
            }
            .padding()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 13.0, repeats: true) { _ in
                showOverlay = false
                startSet = false
                endSet = false
                playAnimation.toggle()
                Timer.scheduledTimer(withTimeInterval: 1.6, repeats: false) { _ in
                    showOverlay = true
                    Timer.scheduledTimer(withTimeInterval: 2.3, repeats: false) { _ in
                        showOverlay = false
                        startSet = true
                        Timer.scheduledTimer(withTimeInterval: 2.6, repeats: false) { _ in
                            showOverlay = true
                            Timer.scheduledTimer(withTimeInterval: 2.6, repeats: false) { _ in
                                showOverlay = false
                                endSet = true
                            }
                        }
                    }
                }
            }
            .fire()
        }
    }
}

#Preview {
    SetStartEndTutorial()
        .environmentObject(ContentModel())
        .environmentObject(AlgorithmModel())
        .environmentObject(CanvasModel())
}
