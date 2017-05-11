//
//  ACEDrawingToolState.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/9.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingToolState: NSObject {
    var hasPositionObject: Bool {
        return positionObject != nil
    }
    private(set) var positionObject: Any?
    
    private(set) var tool: ACEDrawingTool?
    
    class func state(for tool: ACEDrawingTool, capturePosition: Bool = false) -> ACEDrawingToolState {
        let state = ACEDrawingToolState()
        state.tool = tool
        if capturePosition {
            state.positionObject = tool.captureToolState()
        }
        return state
    }
    
}
