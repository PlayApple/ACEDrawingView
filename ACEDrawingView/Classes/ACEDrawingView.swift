//
//  ACEDrawingView.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/9.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

enum ACEDrawingToolType {
    case pen
    case line
    case arrow
    case rectagleStroke
    case rectagleFill
    case ellipseStroke
    case ellipseFill
    case eraser
    case draggableText
    case custom
}

enum ACEDrawingMode {
    case scale
    case originalSize
}


class ACEDrawingView: UIView, ACEDrawingLabelViewDelegate {

    var draggableTextFontName: String?
    
    var draggableTextCloseImage = #imageLiteral(resourceName: "sticker_close")
    var draggableTextRotateImage = #imageLiteral(resourceName: "sticker_resize")
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
