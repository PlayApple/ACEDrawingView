//
//  ACEDrawingPenTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/10.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingPenTool: UIBezierPath, ACEDrawingTool {
    var lineColor: UIColor = .red
    var lineAlpha: CGFloat = 0.0
    var lineW: CGFloat = 0.0 // lineWidth
    
    var path: CGMutablePath
    
    override init() {
        path = CGMutablePath()
        super.init()
        
        lineCapStyle = .round
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.addPath(path)
        context.setLineCap(.round)
        context.setLineWidth(lineW)
        context.setStrokeColor(lineColor.cgColor)
        context.setBlendMode(.normal)
        context.setAlpha(lineAlpha)
        context.strokePath()
    }
    
    func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self)
    }
    
    func addPath(previousPreviousPoint p2Point: CGPoint, previousPoint p1Point: CGPoint, currentPoint cpoint: CGPoint) -> CGRect {
        
        let mid1 = p1Point.midPoint(with: p2Point)
        let mid2 = cpoint.midPoint(with: p1Point)
        
        let subpath = CGMutablePath()
        subpath.move(to: mid1)
        subpath.addQuadCurve(to: mid2, control: p1Point)
        return subpath.boundingBox
    }
}
