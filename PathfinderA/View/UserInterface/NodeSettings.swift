//
//  NodeSettings.swift
//  MapWalker
//
//  Created by Denis on 29/8/23.
//

import SwiftUI

struct NodeSettings: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel
    
    let node: Node
    let size: CGSize = CGSize(width: 250, height: 130)
    
    func calculatePosition() -> CGPoint {
        let nodeOnView = canvasData.translateToViewCoordinates(node.coordinates)
        let nodeHalfSize = NodeView.defaultNodeSize * canvasData.globalZoom / 2
        
        let sidePadding = 10.0
        let enoughSpaceAbove = nodeOnView.y - nodeHalfSize > size.height
        let enoughSpaceLeft = nodeOnView.x - nodeHalfSize > size.width + sidePadding
        
        let sideOffset = enoughSpaceLeft ? 0 : min(canvasData.canvasSize.width - (nodeOnView.x + nodeHalfSize + size.width) - sidePadding, 0)
        
        return CGPoint(x: nodeOnView.x + (nodeHalfSize + size.width / 2) * (enoughSpaceLeft ? -1 : 1) + sideOffset,
                       y: nodeOnView.y + (nodeHalfSize + size.height / 1.5) * (enoughSpaceAbove ? -1 : 1))
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundStyle(.thickMaterial)
                .frame(width: size.width, height: size.height)
                .overlay {
                    VStack(alignment: .leading) {
                        Text("Set as Start")
                            .onTapGesture {
                                algorithmData.setStartNode(node: node)
                                canvasData.setState(.none)
                            }
                        Divider()
                        Text("Set as End")
                            .onTapGesture {
                                algorithmData.setGoalNode(node: node)
                                canvasData.setState(.none)
                            }
                        Divider()
                        Text("Remove")
                            .onTapGesture {
                                contentData.removeNode(node: node)
                                canvasData.setState(.none)
                            }
                    }
                    .padding(.horizontal, 15)
                }
                .position(calculatePosition())
        }
    }
}

struct NodeSettings_Previews: PreviewProvider {
    static var previews: some View {
        NodeSettings(node: Node(at: CGPoint()))
            .environmentObject(ContentModel())
            .environmentObject(AlgorithmModel())
            .environmentObject(CanvasModel())
    }
}
