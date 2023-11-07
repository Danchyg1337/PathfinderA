//
//  CanvasButtonSet.swift
//  MapWalker
//
//  Created by Denis on 21/8/23.
//

import SwiftUI

struct CanvasButtonSet: View {
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    
    @State var showNoNodesAlert = false
    @State var showTutorialAlert = false
    
    enum ControlState {
        case ready
        case blocked
    }
    
    var controlButtonsState: ControlState {
        if contentData.nodes.count < 2 {
            return .blocked
        }
        return .ready
    }
    
    var body: some View {
        HStack(alignment: .top) {
            leftButtonSet
                .foregroundColor(CanvasButton.color)
            Spacer()
            if canvasData.sidePanelState == .hidden {
                topButtonSet
                    .foregroundColor(controlButtonsState == .blocked ? .gray : CanvasButton.color)
                Spacer()
            }
            rightButtonSet
                .foregroundColor(CanvasButton.color)
        }
    }
}

extension CanvasButtonSet {
    var leftButtonSet: some View {
        VStack {
            CanvasButton(iconName: "circle.hexagongrid.fill") {
                canvasData.setSidePanelState(canvasData.sidePanelState == .grid ? .hidden : .grid)
            }
            .offset(x: canvasData.sidePanelState == .grid ? -10 : 0)
            
            CanvasButton(iconName: "gearshape.fill") {
                canvasData.setSidePanelState(canvasData.sidePanelState == .settings ? .hidden : .settings)
            }
            .offset(x: canvasData.sidePanelState == .settings ? -10 : 0)
            
            CanvasButton(iconName: "questionmark") {
                if !contentData.nodes.isEmpty {
                    showTutorialAlert.toggle()
                }
                else {
                    canvasData.setTutorialState(.setNodes)
                }
            }
            .offset(x: canvasData.sidePanelState == .help ? -10 : 0)
            .alert(isPresented: $showTutorialAlert) {
                Alert(title: Text("Tutorial"),
                      message: Text("Do you want to launch the tutorial?"),
                      primaryButton: .default(Text("OK")) {
                          canvasData.setTutorialState(.setNodes)
                      },
                      secondaryButton: .default(Text("Cancel"))
                )
            }
        }
    }
    
    var topButtonSet: some View {
        VStack {
            HStack {
                CanvasButton(iconName: "square.fill") {
                    algorithmData.reset()
                    contentData.nodes.forEach( {
                        $0.FValue = 0
                        $0.costFromStart = 0
                        $0.distanceToGoal = 0
                        $0.parent = nil
                    } )
                }
                CanvasButton(iconName: "play.fill") {
                    algorithmData.run()
                    if controlButtonsState == .blocked {
                        showNoNodesAlert.toggle()
                    }
                }
                CanvasButton(iconName: "arrowshape.turn.up.forward.fill") {
                    algorithmData.step()
                    if controlButtonsState == .blocked {
                        showNoNodesAlert.toggle()
                    }
                }
            }
            .alert(isPresented: $showNoNodesAlert) {
                Alert(title: Text("Not enough nodes"),
                      message: Text("Double tap on the canvas or generate a grid using top right button"),
                      dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    var rightButtonSet: some View {
        VStack {
            CanvasButton(iconName: "plus.magnifyingglass") {
                canvasData.zoomIn()
            }
            CanvasButton(iconName: "minus.magnifyingglass") {
                canvasData.zoomOut()
            }
            if canvasData.canvasMode == .moving {
                CanvasButton(iconName: "arrow.up.and.down.and.arrow.left.and.right") {
                    canvasData.setMode(.picking)
                }
            }
            else if canvasData.canvasMode == .picking {
                CanvasButton(iconName: "cursorarrow") {
                    canvasData.setMode(.moving)
                }
            }
        }
    }
}

struct CanvasButtonSet_Previews: PreviewProvider {
    static var previews: some View {
        CanvasButtonSet()
            .environmentObject(CanvasModel())
            .environmentObject(ContentModel())
            .environmentObject(AlgorithmModel())
    }
}
