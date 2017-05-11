//
//  ACEDrawingTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/9.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

extension CGPoint {
    func midPoint(with point: CGPoint) -> CGPoint {
        return CGPoint(x: (x + point.x) * 0.5, y: (y + point.y) * 0.5)
    }
}

protocol ACEDrawingTool {
    var lineColor: UIColor { get set }
    var lineAlpha: CGFloat { get set }
    var lineW: CGFloat { get set }
    
    func draw()
    func captureToolState() -> ACEDrawingToolState
}

extension ACEDrawingTool {
    func setInitialPoint(_ point: CGPoint) { }
    func move(from startPoint: CGPoint, to endPoint: CGPoint) { }
    func applyToolState(_ state: ACEDrawingToolState) { }
}
