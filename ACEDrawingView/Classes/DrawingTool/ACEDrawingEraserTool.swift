//
//  ACEDrawingEraserTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/10.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingEraserTool: ACEDrawingPenTool {
    override func draw() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()
        
        context.addPath(path)
        context.setLineCap(.round)
        context.setLineWidth(lineW)
        context.setBlendMode(.clear)
        context.strokePath()
        context.restoreGState()
    }
    
    override func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self)
    }
}
