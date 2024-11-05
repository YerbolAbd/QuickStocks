//
//  StockChartView.swift
//  QuickStocks
//
//  Created by Ербол on 04.11.2024.
//

import UIKit

class StockChartView: UIView {
    private let graphLayer = CAShapeLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        layer.cornerRadius = 4
        clipsToBounds = true
        layer.addSublayer(graphLayer)
    }

    func drawRandomGraph(isRising: Bool) {
        graphLayer.path = nil

        let path = UIBezierPath()
        let pointSpacing = bounds.width / 10
        let maxY = bounds.height - 5
        let minY: CGFloat = 5
        var currentY = CGFloat.random(in: minY...maxY)
        path.move(to: CGPoint(x: 0, y: currentY))

        for i in 1...10 {
            let x = CGFloat(i) * pointSpacing
            let yOffset = CGFloat.random(in: -15...15)
            currentY = min(max(currentY + yOffset, minY), maxY)
            path.addLine(to: CGPoint(x: x, y: currentY))
        }

        graphLayer.path = path.cgPath
        graphLayer.lineWidth = 2
        graphLayer.strokeColor = isRising ? UIColor.green.cgColor : UIColor.red.cgColor
        graphLayer.fillColor = UIColor.clear.cgColor
    }
}
