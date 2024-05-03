//
//  PixellatedButton.swift
//  Whats The Score
//
//  Created by Curt McCune on 4/25/24.
//

import Foundation
import UIKit

class PixellatedButton: UIButton {
    
    var borderColor: UIColor = UIColor.textColor
    var pixelSize: CGFloat = 3.0 // The size of each 'pixel' in the border
    var cornerRadiusInPixels: Int = 4 // The radius of the corner in terms of 'pixels'
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        // Setup title color for normal state
        setTitleColor(borderColor, for: .normal)
        
        // Calculate disabled and highlighted colors based on the normal state color
        let disabledHighlightedColor = borderColor.withAlphaComponent(0.5)
        setTitleColor(disabledHighlightedColor, for: .disabled)
        setTitleColor(disabledHighlightedColor, for: .highlighted)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard pixelSize > 0 else { return }
        
        // Adjust the border color based on the button state
        let currentBorderColor = isHighlighted || !isEnabled ? borderColor.withAlphaComponent(0.5) : borderColor
        
        // Begin graphics context for drawing
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        currentBorderColor.setFill()
        
        let adjustedWidth = rect.width - 2 * (CGFloat(cornerRadiusInPixels) * pixelSize)
        let topRect = CGRect(x: CGFloat(cornerRadiusInPixels) * pixelSize, y: 0, width: adjustedWidth, height: pixelSize)
        let bottomRect = CGRect(x: CGFloat(cornerRadiusInPixels) * pixelSize, y: rect.height - pixelSize, width: adjustedWidth, height: pixelSize)
        UIBezierPath(rect: topRect).fill()
        UIBezierPath(rect: bottomRect).fill()
        
        // Draw side border pixels
        for y in stride(from: pixelSize * CGFloat(cornerRadiusInPixels), to: rect.height - pixelSize * CGFloat(cornerRadiusInPixels), by: pixelSize) {
            drawPixel(rect: CGRect(x: 0, y: y, width: pixelSize, height: pixelSize))
            drawPixel(rect: CGRect(x: rect.width - pixelSize, y: y, width: pixelSize, height: pixelSize))
        }
        
        // Draw corner pixels
        for i in 0..<cornerRadiusInPixels {
            let offset = CGFloat(cornerRadiusInPixels - i - 1) * pixelSize

            // Top-left corner
            drawPixel(rect: CGRect(x: CGFloat(i) * pixelSize, y: offset, width: pixelSize, height: pixelSize))

            // Top-right corner
            drawPixel(rect: CGRect(x: rect.width - pixelSize * CGFloat(i + 1), y: offset, width: pixelSize, height: pixelSize))

            // Bottom-left corner
            drawPixel(rect: CGRect(x: CGFloat(i) * pixelSize, y: rect.height - pixelSize - offset, width: pixelSize, height: pixelSize))

            // Bottom-right corner
            drawPixel(rect: CGRect(x: rect.width - pixelSize * CGFloat(i + 1), y: rect.height - pixelSize - offset, width: pixelSize, height: pixelSize))
        }
        
        context.restoreGState()
    }
    
    // Add state change handlers to redraw when the state changes
    override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            setNeedsDisplay()
        }
    }
    
    private func drawPixel(rect: CGRect) {
        let path = UIBezierPath(rect: rect)
        path.fill()
    }
}
