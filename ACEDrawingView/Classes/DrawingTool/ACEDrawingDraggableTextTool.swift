//
//  ACEDrawingDraggableTextTool.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/10.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingDraggableTextTool: NSObject, ACEDrawingTool {

    var lineColor: UIColor = .clear
    var lineAlpha: CGFloat = 0.0
    var lineW: CGFloat = 0.0 // lineWidth
    
    var drawingView: ACEDrawingView!
    var labelView: ACEDrawingLabelView?
    
    var capturePositionObject: Any? {
        guard let labelView = labelView else {
            return nil
        }
        return ACEDrawingLabelViewTransform(transform: labelView.transform, atCenter: labelView.center, withBounds: labelView.bounds)
    }
    
    private(set) var redoPositions =  [ACEDrawingLabelViewTransform]()
    private(set) var undoPositions =  [ACEDrawingLabelViewTransform]()
    
    func setInitialPoint(_ point: CGPoint) {
        let frame = CGRect(origin: point, size: CGSize(width: 50, height: 100))
        let labelView = ACEDrawingLabelView(frame: frame)
        labelView.delegate = drawingView
        labelView.fontSize = 18.0
        labelView.fontName  = drawingView.draggableTextFontName ?? UIFont.systemFont(ofSize: labelView.fontSize).fontName
        labelView.textColor = lineColor;
        labelView.closeImage = drawingView.draggableTextCloseImage
        labelView.rotateImage = drawingView.draggableTextRotateImage
        self.labelView = labelView
    }
    
    func draw() {
        if let labelView = labelView, labelView.superview == nil {
            drawingView.addSubview(labelView)
        }
    }
    
    func applyToolState(_ state: ACEDrawingToolState) {
        if state.hasPositionObject {
            if let t = state.positionObject as? ACEDrawingLabelViewTransform {
                applyTransform(t)
            }
        }
        draw()
    }
    
    func captureToolState() -> ACEDrawingToolState {
        return ACEDrawingToolState.state(for: self, capturePosition: true)
    }
    
    func hideHandle() {
        labelView?.isShowingEditingHandles = false
    }
    
    private func applyTransform(_ transform: ACEDrawingLabelViewTransform) {
        UIView.animate(withDuration: 0.3) { 
            guard let lable = self.labelView else { return }
            lable.center = transform.center
            lable.transform = transform.transform
            lable.bounds = transform.bounds
            lable.resize(in: transform.bounds)
        }
    }
    
    func capturePosition() {
        if let lable = self.labelView {
            undoPositions.append(ACEDrawingLabelViewTransform(transform: lable.transform,
                                                              atCenter: lable.center,
                                                              withBounds: lable.bounds))
        }
        
        // clear redoPositions
        redoPositions.removeAll()
    }
    
    func undraw() {
        labelView?.removeFromSuperview()
    }
    
    func canRedo() -> Bool {
        return redoPositions.count > 0 && labelView?.superview != nil
    }
    
    func redo() -> Bool {
        // add transform to undoPositions
        if let lable = self.labelView {
            undoPositions.append(ACEDrawingLabelViewTransform(transform: lable.transform,
                                                              atCenter: lable.center,
                                                              withBounds: lable.bounds))
        }
        
        // apply transform
        if let t = redoPositions.last {
            applyTransform(t)
            
            // remove transform from redoPositions
            redoPositions.removeLast()
        }
        
        return !canRedo()
    }
    
    func canUndo() -> Bool {
        return undoPositions.count > 0
    }
    
    func undo() {
        // add transform to redoPositions
        if let lable = self.labelView {
            redoPositions.append(ACEDrawingLabelViewTransform(transform: lable.transform,
                                                              atCenter: lable.center,
                                                              withBounds: lable.bounds))
        }
        
        // apply transform
        if let t = undoPositions.last {
            applyTransform(t)
            
            // remove transform from undoPositions
            undoPositions.removeLast()
        }
    }
}
