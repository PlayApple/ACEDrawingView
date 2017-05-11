//
//  ACEDrawingArrowTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/11.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingArrowTool: NSObject, ACEDrawingTool {
    var lineColor: UIColor = .clear
    var lineAlpha: CGFloat = 0.0
    var lineW: CGFloat = 0.0 // lineWidth
    
    var firstPoint: CGPoint = CGPoint.zero
    var lastPoint: CGPoint = CGPoint.zero
    
    func setInitialPoint(_ point: CGPoint) {
        firstPoint = point
    }
    
    func move(from startPoint: CGPoint, to endPoint: CGPoint) {
        lastPoint = endPoint
    }
    
    func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let capHeight = lineW * 4
        // set the line properties
        context.setStrokeColor(lineColor.cgColor)
        context.setLineCap(.square)
        context.setLineWidth(lineW)
        context.setAlpha(lineAlpha)
        
        // draw the line
        context.move(to: firstPoint)
        context.addLine(to: lastPoint)
        
        // draw arrow cap
        let a = angle(withFirstPoint: firstPoint, secondPoint: lastPoint)
        var p1 = point(withAngle: a + 7 * CGFloat.pi / 8, distance: capHeight)
        var p2 = point(withAngle: a - 7 * CGFloat.pi / 8, distance: capHeight)
        p1 = CGPoint(x: lastPoint.x + p1.x, y: lastPoint.y + p1.y)
        p2 = CGPoint(x: lastPoint.x + p2.x, y: lastPoint.y + p2.y)
        
        let endPointOffset = point(withAngle: a, distance: lineW)
        
        context.move(to: p1)
        context.addLine(to: CGPoint(x: lastPoint.x + endPointOffset.x, y: lastPoint.y + endPointOffset.y))
        context.addLine(to: p2)
        context.strokePath()
    }
    
    func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self)
    }
    
    private func angle(withFirstPoint point: CGPoint, secondPoint: CGPoint) -> CGFloat {
        let dx = secondPoint.x - point.x
        let dy = secondPoint.y - point.y
        let angle = atan2(dy, dx)
        
        return angle
    }
    
    private func point(withAngle angle: CGFloat, distance: CGFloat) -> CGPoint {
        let x = distance * cos(angle)
        let y = distance * sin(angle)
        return CGPoint(x: x, y: y)
    }
    
}
