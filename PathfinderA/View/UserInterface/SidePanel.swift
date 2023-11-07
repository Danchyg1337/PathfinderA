import Foundation
import SwiftUI

struct SidePanel: View {
    @EnvironmentObject var contentData: ContentModel
    @EnvironmentObject var canvasData: CanvasModel
    @EnvironmentObject var algorithmData: AlgorithmModel

    private func reloadData() {
        contentData.reloadEdges()
        algorithmData.reset()
        algorithmData.setStartNode(node: contentData.nodes.first!)
        algorithmData.setGoalNode(node: contentData.nodes.last!)
    }
    
    var body: some View {
        switch canvasData.sidePanelState {
        case .grid:
            SidePanelView(header: "Generate Grid") {
                ScrollView {
                    VStack(alignment: .leading) {
                        SidePanelButton(imageName: "circle.grid.2x2", text: "Small Grid") {
                            contentData.setNodes(nodes: SquareGrid.generate(size: 3))
                            reloadData()
                        }
                        SidePanelButton(imageName: "circle.grid.3x3", text: "Medium Grid") {
                            contentData.setNodes(nodes: SquareGrid.generate(size: 5))
                            reloadData()
                        }
                        SidePanelButton(imageName: "circle.grid.3x3", text: "Large Grid") {
                            contentData.setNodes(nodes: SquareGrid.generate(size: 10))
                            reloadData()
                        }
                        SidePanelButton(imageName: "circle.grid.3x3", text: "Random Grid Maze") {
                            contentData.setNodes(nodes: SquareGrid.generate(size: 10, maze: true))
                            reloadData()
                        }
                        SidePanelButton(imageName: "circle.hexagongrid.fill", text: "Random Maze") {
                            contentData.setNodes(nodes: MazeGrid.generate(size: 10))
                            reloadData()
                        }
                    }
                }
            }
        case .settings:
            SidePanelView(header: "Settings") {
                ScrollView {
                    Toggle(isOn: $canvasData.showNodeValues) {
                        Text("Show node's values")
                    }
                    .toggleStyle(SidePanelToggleStyle())
                    VStack {
                        Text("Heuristic preference")
                            .offset(y: 8)
                        HStack {
                            Text("Distance")
                            Slider(value: $algorithmData.heuristicValue, in: 0.2...1.8, step: 0.1)
                            Text("Cost")
                        }
                    }
                }
                .modifier(SidePanelTextModifier())
            }
        case .help:
            SidePanelView(header: "Help") {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text("Double tap on the screen to set a new node")
                            .padding(.bottom, 10)
                        Text("Hold a node to move it around")
                            .padding(.bottom, 10)
                        Text("Drag to connect a node")
                            .padding(.bottom, 10)
                    }
                    .modifier(SidePanelTextModifier())
                }
            }
        case .hidden:
            EmptyView()
        }
    }
}

struct SidePanel_Previews: PreviewProvider {
    static var previews: some View {
        SidePanel()
            .environmentObject(CanvasModel())
    }
}


struct SidePanelView<Content: View>: View {
    let content: Content
    let header: String
    init(header text: String, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.header = text
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(header)
                .padding(.leading, 6)
                .padding(.bottom, -8)
                .foregroundColor(.gray)
            Divider()
            content
                .padding(.leading, 5)
        }
        .background(.thinMaterial)
    }
}

struct SidePanelToggleStyle: ToggleStyle {
    let width: CGFloat = 40 * 1.3
    let height: CGFloat = 25 * 1.3
    let cornerRadius: CGFloat = 20
    let showLetters: Bool = false
    let showLines: Bool = false
    let onColor: Color = .green
    let offColor: Color = .red
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            ZStack{
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(configuration.isOn ? onColor : offColor)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(lineWidth: 2)
                    .fill(Color.gray)
                    .shadow(radius: 2, x: -2, y: 2)
                    .shadow(radius: 2, x: -2, y: 2)
                    .shadow(radius: 2, x: -2, y: 2)
                    .mask{
                        RoundedRectangle(cornerRadius: cornerRadius)
                    }
                if showLetters {
                    Text("I")
                        .foregroundColor(.gray)
                        .offset(x: -width * 0.25)
                    Text("O")
                        .foregroundColor(.gray)
                        .offset(x: width * 0.25)
                }
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: width * 0.5, height: height * 0.8)
                        .foregroundStyle(.regularMaterial)
                    if showLines {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .rotationEffect(Angle(degrees: 90))
                            .foregroundColor(.gray)
                            .scaleEffect(x: 0.3, y: 0.2)
                    }
                }
                .offset(x: 0.18 * (configuration.isOn ? width : -width))
                .shadow(radius: 5, x: -2, y: 2)
            }
            .frame(width: width, height: height)
            .padding(1)
            .onTapGesture {
                withAnimation {
                    configuration.isOn.toggle()
                }
            }
        }
    }
}
