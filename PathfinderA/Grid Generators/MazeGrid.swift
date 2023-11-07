import Foundation

class MazeGrid {
    static let gapSize: CGFloat = 75
    static func generate(size: Int) -> [Node] {
        var grid = [Node]()
        let totalSizeOnCanvas = CGFloat(size - 1) * gapSize
        for y in 0..<size {
            let offset = gapSize / 2 * CGFloat(y % 2)
            for x in 0..<size {
                grid.append(Node(at: CGPoint(x: -(totalSizeOnCanvas / 2) + CGFloat(x) * gapSize + offset,
                                             y: -(totalSizeOnCanvas / 2) + CGFloat(y) * gapSize)))
            }
        }
        for (index, node) in grid.enumerated() {
            let column = index % size
            let row: Int = index / size
            let notFirstColumn = column != 0
            let notLastColumn = column != size - 1
            let notFirstRow = row != 0
            let notLastRow = row != size - 1
            let evenRow = row % 2 == 0
            if notFirstColumn {
                node.leaves.append(grid[index - 1])
            }
            if notLastColumn {
                node.leaves.append(grid[index + 1])
            }
            if notFirstRow {
                node.leaves.append(grid[index - size])
            }
            if notLastRow {
                node.leaves.append(grid[index + size])
            }
            
            if evenRow {
                if notLastRow && notFirstColumn {
                    node.leaves.append(grid[index + size - 1])
                }
                if notFirstRow && notFirstColumn {
                    node.leaves.append(grid[index - size - 1])
                }
            }
            else {
                if notLastRow && notLastColumn {
                    node.leaves.append(grid[index + size + 1])
                }
                if notFirstRow && notLastColumn {
                    node.leaves.append(grid[index - size + 1])
                }
            }
        }
        gridToMaze(&grid, start: grid.first!)
        return grid
    }
}
