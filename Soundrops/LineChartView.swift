import UIKit

class LineChartView: UIView {

    // Data points and animation settings
    public var dataPoints: [CGFloat] = [0]
    private var animationDuration: TimeInterval = 1.0
    private var isAnimating: Bool = false

    // Customize these values as needed
    private let lineColor = UIColor.red
    private let gridColor = UIColor.gray.withAlphaComponent(0.5)
    private let gridLinAaeWidth: CGFloat = 0.5

    // MARK: - Animation

    func animateLine(to newPoints: [CGFloat]) {
        guard !isAnimating else { return }
        isAnimating = true

        UIView.animate(withDuration: animationDuration, animations: {
            self.dataPoints = newPoints
            self.setNeedsDisplay() // Trigger redrawing
        }, completion: { _ in
            self.isAnimating = false
        })
    }

    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        // Calculate drawing dimensions
        let width = rect.width
        let height = rect.height
        let xMargin = width * 0.1
        let yMargin = height * 0.1
        let plotWidth = width - 2 * xMargin
        let plotHeight = height - 2 * yMargin

        // Draw grid lines
        context.setStrokeColor(gridColor.cgColor)
        context.setLineWidth(gridLineWidth)

        for y in stride(from: yMargin, through: height - yMargin, by: plotHeight / 5.0) {
            context.beginPath()
            context.move(to: CGPoint(x: xMargin, y: y))
            context.addLine(to: CGPoint(x: width - xMargin, y: y))
            context.strokePath()
        }

        // Draw the line graph
        context.setStrokeColor(lineColor.cgColor)
        context.setLineWidth(2.0)

        let xStep = plotWidth / CGFloat(dataPoints.count - 1)
        let yStep = plotHeight / dataPoints.max()!

        for (index, point) in dataPoints.enumerated() {
            let x = xMargin + CGFloat(index) * xStep
            let y = height - yMargin - point * yStep
            if index == 0 {
                context.move(to: CGPoint(x: x, y: y))
            } else {
                context.addLine(to: CGPoint(x: x, y: y))
            }
        }

        context.strokePath()
    }
}
