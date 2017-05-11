//
//  ACEDrawingRectangleTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/10.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingRectangleTool: NSObject, ACEDrawingTool {

    var lineColor: UIColor = .clear
    var lineAlpha: CGFloat = 0.0
    var lineW: CGFloat = 0.0 // lineWidth
    
    var fill = false
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
        
        context.setAlpha(lineAlpha)
        let rectToFill = CGRect(x: firstPoint.x, y: firstPoint.y, width: lastPoint.x - firstPoint.x, height: lastPoint.y - firstPoint.y)
        
        if fill {
            context.setFillColor(lineColor.cgColor)
            context.fill(rectToFill)
        } else {
            context.setStrokeColor(lineColor.cgColor)
            context.setLineWidth(lineW)
            context.fill(rectToFill)
        }
    }
    
    func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self)
    }

}
