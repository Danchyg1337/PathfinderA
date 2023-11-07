//
//  RunAlgorithmTutorial.swift
//  MapWalker
//
//  Created by Denis on 17/10/23.
//

import SwiftUI

struct RunAlgorithmTutorial: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    @State var playAnimation = false
    @State var stateIndex = 0
    @State var textIndex = 0
    
    let hints: [Color: String] = [.red: "Closed Nodes",
                                 .green: "Opened Nodes",
                                 .purple: "Final Path"]
    
    let states: [Int: [Int: NodeView.NodeState]] = [0: [0: .start, 1: .clear, 2: .clear, 3: .goal],
                                                    1: [0: .locked(color: .red), 1: .locked(color: .green), 2: .locked(color: .green), 3: .goal],
                                                    2: [0: .locked(color: .red), 1: .locked(color: .green), 2: .locked(color: .red), 3: .goal],
                                                    3: [0: .locked(color: .red), 1: .locked(color: .red), 2: .locked(color: .red), 3: .locked(color: .green)],
                                                    4: [0: .locked(color: .purple), 1: .locked(color: .purple), 2: .locked(color: .red), 3: .locked(color: .purple)]]
    
    let texts = ["Press on play button to run the algorithm", "Press on a square to reset", "Press on an arrow to do a step of the algorithm"]
    
    static let firstNodePosition = CGSize(width: 0, height: -150)
    static let secondNodePosition = CGSize(width: -65, height: -10)
    static let thirdNodePosition = CGSize(width: 45, height: 50)
    static let fourthNodePosition = CGSize(width: 20, height: 150)
    static let pointerOffset = CGSize(width: 35, height: 50)
    
    private struct AnimationValues {
        var scale = 1.0
        var offset = CGSize()
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    VStack (alignment: .leading) {
                        ForEach(Array(hints.keys), id: \.self) { key in
                            HStack {
                                Circle()
                                    .frame(width: 15)
                                    .foregroundColor(key)
                                Text(hints[key]!)
                                    .font(Font.system(size: 13))
                            }
                        }
                        Divider()
                        HStack(alignment: .top) {
                            Image(systemName: "lock.fill")
                                .font(Font.system(size:  16))
                                .opacity(0.3)
                                .foregroundColor(.gray)
                                .offset(x: -2)
                            Text("All the nodes affected by the algorithm become locked")
                                .font(Font.system(size: 13))
                        }
                    }
                    .frame(width: 120, height: 140)
                    .padding(10)
                    .background {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(Color("ButtonSetColor"))
                            .opacity(0.2)
                    }
                    .offset(x: -110, y: -200)
                    
                    EdgeView(start: CGPoint(x: RunAlgorithmTutorial.firstNodePosition.width + geometry.size.width / 2,
                                            y: RunAlgorithmTutorial.firstNodePosition.height + geometry.size.height / 2),
                             end: CGPoint(x: RunAlgorithmTutorial.secondNodePosition.width + geometry.size.width / 2,
                                          y: RunAlgorithmTutorial.secondNodePosition.height + geometry.size.height / 2), globalZoom: 1)
                    EdgeView(start: CGPoint(x: RunAlgorithmTutorial.firstNodePosition.width + geometry.size.width / 2,
                                            y: RunAlgorithmTutorial.firstNodePosition.height + geometry.size.height / 2),
                             end: CGPoint(x: RunAlgorithmTutorial.thirdNodePosition.width + geometry.size.width / 2,
                                          y: RunAlgorithmTutorial.thirdNodePosition.height + geometry.size.height / 2), globalZoom: 1)
                    EdgeView(start: CGPoint(x: RunAlgorithmTutorial.secondNodePosition.width + geometry.size.width / 2,
                                            y: RunAlgorithmTutorial.secondNodePosition.height + geometry.size.height / 2),
                             end: CGPoint(x: RunAlgorithmTutorial.fourthNodePosition.width + geometry.size.width / 2,
                                          y: RunAlgorithmTutorial.fourthNodePosition.height + geometry.size.height / 2), globalZoom: 1)
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false, nodeState: states[stateIndex]![0]!)
                        .offset(RunAlgorithmTutorial.firstNodePosition)
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false,
                             nodeState: states[stateIndex]![1]!)
                    .offset(RunAlgorithmTutorial.secondNodePosition)
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false,
                             nodeState: states[stateIndex]![2]!)
                    .offset(RunAlgorithmTutorial.thirdNodePosition)
                    NodeView(node: Node(at: CGPoint()), nodeSize: 50, showValues: false,
                             nodeState: states[stateIndex]![3]!)
                    .offset(RunAlgorithmTutorial.fourthNodePosition)
                    
                    HStack {
                        CanvasButton(iconName: "square.fill") {
                        }
                        CanvasButton(iconName: "play.fill") {
                        }
                        CanvasButton(iconName: "arrowshape.turn.up.forward.fill") {
                        }
                    }
                    .foregroundColor(Color("ButtonSetColor"))
                    .offset(y: -geometry.size.height / 2 + 30)
                    
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
                                LinearKeyframe(1.0, duration: 1.5)
                                LinearKeyframe(1.0, duration: 2.0)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 2.75)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 2.75)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                
                                LinearKeyframe(1.0, duration: 1.0)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 1.0)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                                LinearKeyframe(1.0, duration: 1.0)
                                LinearKeyframe(0.9, duration: 0.15)
                                LinearKeyframe(1.0, duration: 0.15)
                            }
                            
                            KeyframeTrack(\.offset) {
                                LinearKeyframe(CGSize(), duration: 1.5)
                                LinearKeyframe(CGSize(width: 35, height: -260), duration: 1.5)
                                LinearKeyframe(CGSize(width: 35, height: -260), duration: 2.0)
                                LinearKeyframe(CGSize(width: -5, height: -260), duration: 1.5)
                                LinearKeyframe(CGSize(width: -5, height: -260), duration: 1.5)
                                LinearKeyframe(CGSize(width: 70, height: -260), duration: 1.5)
                                LinearKeyframe(CGSize(width: 70, height: -260), duration: 1.5)
                            }
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            Spacer()
            HStack {
                Text(texts[textIndex])
                NextButton {
                    canvasData.setTutorialState(CanvasModel.TutorialState.none)
                }
            }
            .padding()
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 16.0, repeats: true) { _ in
                playAnimation.toggle()
                textIndex = 0
                stateIndex = 0
                Timer.scheduledTimer(withTimeInterval: 3.6, repeats: false) { _ in
                    stateIndex = 4
                    textIndex = 1
                    Timer.scheduledTimer(withTimeInterval: 3.2, repeats: false) { _ in
                        stateIndex = 0
                        textIndex = 2
                        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                            stateIndex = 1
                            Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
                                stateIndex = 2
                                Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
                                    stateIndex = 3
                                    Timer.scheduledTimer(withTimeInterval: 1.3, repeats: false) { _ in
                                        stateIndex = 4
                                    }
                                }
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
    RunAlgorithmTutorial()
        .environmentObject(ContentModel())
        .environmentObject(AlgorithmModel())
        .environmentObject(CanvasModel())
}
