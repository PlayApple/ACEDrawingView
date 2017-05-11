//
//  ACEDrawingLineTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/10.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingLineTool: NSObject, ACEDrawingTool {
    var lineColor: UIColor = .clear
    var lineAlpha: CGFloat = 0.0
    var lineW: CGFloat = 0.0 // lineWidth
    
    var firstPoint: CGPoint = CGPoint.zero
    var lastPoint: CGPoint = CGPoint.zero
    
    func setInitialPoint(_ point: CGPoint) {
        firstPoint = point
    }
    
    func move(from startPoint: CGPoint, to endPoint: CGPoint) {
        lastPoint = endPoint;
    }
    
    func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // set the line properties
        context.setStrokeColor(lineColor.cgColor)
        context.setLineCap(.round)
        context.setLineWidth(lineW)
        context.setAlpha(lineAlpha)
        
        // draw the line
        context.move(to: firstPoint)
        context.addLine(to: lastPoint)
        context.strokePath()
    }
    
    func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self)
    }
}
