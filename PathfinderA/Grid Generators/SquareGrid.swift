import Foundation

class SquareGrid {
    static let gapSize: CGFloat = 75
    static func generate(size: Int, maze: Bool = false) -> [Node] {
        var grid = [Node]()
        let totalSizeOnCanvas = CGFloat(size - 1) * gapSize
        for y in 0..<size {
            for x in 0..<size {
                grid.append(Node(at: CGPoint(x: -(totalSizeOnCanvas / 2) + CGFloat(x) * gapSize,
                                             y: -(totalSizeOnCanvas / 2) + CGFloat(y) * gapSize)))
            }
        }
        for (index, node) in grid.enumerated() {
            let column = index % size
            let row: Int = index / size
            if column != 0 {
                node.leaves.append(grid[index - 1])
            }
            if column != size - 1 {
                node.leaves.append(grid[index + 1])
            }
            if row != 0 {
                node.leaves.append(grid[index - size])
            }
            if row != size - 1 {
                node.leaves.append(grid[index + size])
            }
        }
        if maze {
            gridToMaze(&grid, start: grid.first!)
        }
        return grid
    }
}
