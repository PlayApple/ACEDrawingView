//
//  ACEDrawingEllipseTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/10.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingEllipseTool: NSObject, ACEDrawingTool {
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
        
        // draw the ellipse
        let rectToFill = CGRect(origin: firstPoint, size: CGSize(width: lastPoint.x - firstPoint.x, height: lastPoint.y - firstPoint.y))
        
        if fill {
            context.setFillColor(lineColor.cgColor)
            context.fillEllipse(in: rectToFill)
        } else {
            context.setStrokeColor(lineColor.cgColor)
            context.setLineWidth(lineW)
            context.strokeEllipse(in: rectToFill)
        }
    }
    
    func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self)
    }

}
