//
//  ACEDrawingLabelView.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/8.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ACEDrawingLabelView: UIView {
    /// Text Value
    var textValue: String? {
        set{
            labelTextField.text = newValue
        }
        get{
            return labelTextField.text
        }
    }
    
    /// ext color.
    /// Default: white color.
    var textColor: UIColor {
        set{
            labelTextField.textColor = newValue
        }
        get{
            return labelTextField.textColor ?? .white
        }
    }
    
    /// Returns text alpha.
    var textAlpha: CGFloat {
        set{
            labelTextField.alpha = newValue
        }
        get{
            return labelTextField.alpha
        }
    }
    
    /// Border stroke color.
    /// Default: red color.
    var borderColor: UIColor {
        set{
            border.strokeColor = newValue.cgColor
        }
        get{
            if let strokeColor = border.strokeColor {
                return UIColor(cgColor: strokeColor)
            }
            return .red
        }
    }
    
    /// Name of text field font.
    /// Default: current system font.
    var fontName: String {
        set{
            labelTextField.font = UIFont(name: newValue, size: fontSize)
            labelTextField.adjustsWidthToFillItsContents()
        }
        get{
            return labelTextField.font?.fontName ?? UIFont.systemFont(ofSize: fontSize).fontName
        }
    }
    
    /// Size of text field font.
    /// Default: current system font size.
    var fontSize: CGFloat {
        set{
            labelTextField.font = UIFont(name: fontName, size: newValue)
            labelTextField.adjustsWidthToFillItsContents()
        }
        get{
            return labelTextField.font?.pointSize ?? UIFont.systemFontSize
        }
    }
    
    /// Image for close button.
    var closeImage: UIImage? {
        set{
            closeButton.setImage(newValue, for: .normal)
        }
        get{
            return closeButton.image(for: .normal)
        }
    }
    
    /// Image for rotation button.
    var rotateImage: UIImage? {
        set{
            rotateButton.setImage(newValue, for: .normal)
        }
        get{
            return rotateButton.image(for: .normal)
        }
    }
    
    /// Placeholder.
    var attributedPlaceholder: NSAttributedString? {
        set{
            labelTextField.attributedPlaceholder = newValue
            labelTextField.adjustsWidthToFillItsContents()
        }
        get{
            return labelTextField.attributedPlaceholder
        }
    }
    
    /// Shows content shadow.
    /// Default: true.
    var enableContentShadow: Bool {
        set{
            layer.shadowColor = newValue ? UIColor.black.cgColor : UIColor.clear.cgColor
            layer.shadowOffset = newValue ? CGSize(width: 0, height: 5) : .zero
            layer.shadowOpacity = newValue ? 1 : 0
            layer.shadowRadius = newValue ? 4 : 0
        }
        get{
            return layer.shadowOpacity != 0
        }
    }
    
    /// Shows close button.
    /// Default: true.
    var enableClose: Bool {
        set{
            closeButton.isHidden = !newValue
            closeButton.isUserInteractionEnabled = newValue
        }
        get{
            return closeButton.isUserInteractionEnabled
        }
    }
    
    /// Shows rotate/resize butoon.
    /// Default: true.
    var enableRotate: Bool {
        set{
            rotateButton.isHidden = !newValue
            rotateButton.isUserInteractionEnabled = newValue
        }
        get{
            return rotateButton.isUserInteractionEnabled
        }
    }
    
    /// Resticts movements in superview bounds.
    /// Default: false.
    var enableMoveRestriction = false
    
    /// Check if underlying textField is first responder
    var isEditing: Bool {
        return isShowingEditingHandles
    }
    
    /// Base delegate protocols.
    weak var delegate: ACEDrawingLabelViewDelegate?
    
    var isShowingEditingHandles: Bool {
        set {
            delegate?.labelViewWillShowEditingHandles(self)
            
            enableClose = newValue
            enableRotate = newValue
            refresh()
            
            delegate?.labelViewDidShowEditingHandles(self)
        }
        get {
            return enableClose
        }
    }
    
    fileprivate var globalInset: CGFloat!
    
    fileprivate var initialBounds: CGRect!
    fileprivate var initialDistance: CGFloat!
    
    fileprivate var beginningPoint: CGPoint!
    fileprivate var beginningCenter: CGPoint!
    
    fileprivate var touchLocation: CGPoint!
    
    fileprivate var deltaAngle: CGFloat!
    fileprivate var beginBounds: CGRect!
    
    private var border: CAShapeLayer!
    fileprivate var labelTextField: UITextField!
    private var rotateButton: UIButton!
    private var closeButton: UIButton!
    
    
    private func refresh() {
        guard let superview = self.superview else {
            return
        }
        
        let scale = superview.transform.scale
        let t = CGAffineTransform(scaleX: scale.width, y: scale.height)
        closeButton.transform = t.inverted()
        rotateButton.transform = t.inverted()
        
        if isShowingEditingHandles {
            labelTextField.layer.addSublayer(border)
        } else {
            border.removeFromSuperlayer()
        }
    }
    
    override func didMoveToSuperview() {
        superview?.didMoveToSuperview()
        refresh()
    }
    
    override var frame: CGRect {
        didSet {
            refresh()
        }
    }
    
    override init(frame: CGRect) {
        let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: max(25, frame.size.width), height: max(25, frame.size.height))
        super.init(frame: newFrame)
        
        globalInset = 12
        
        backgroundColor = .clear
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        labelTextField = UITextField(frame: bounds.insetBy(dx: globalInset, dy: globalInset))
        labelTextField.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        labelTextField.clipsToBounds = true
        labelTextField.delegate = self
        labelTextField.backgroundColor = .clear
        labelTextField.tintColor = .red
        labelTextField.textColor = .white
        labelTextField.text = ""
        
        border = CAShapeLayer()
        border.fillColor = nil
        border.lineDashPattern = [4, 3]
        borderColor = .red
        
        insertSubview(labelTextField, at: 0)
        
        closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: globalInset * 2, height: globalInset * 2))
        closeButton.autoresizingMask = [.flexibleRightMargin, .flexibleBottomMargin]
        closeButton.backgroundColor = .white
        closeButton.layer.cornerRadius = globalInset - 5
        closeButton.isUserInteractionEnabled = true
        addSubview(closeButton)
        
        rotateButton = UIButton(frame: CGRect(x: bounds.size.width - globalInset * 2,
                                              y: bounds.size.height - globalInset * 2,
                                              width: globalInset * 2,
                                              height: globalInset * 2))
        rotateButton.autoresizingMask = [.flexibleLeftMargin, .flexibleTopMargin]
        rotateButton.backgroundColor = .white
        rotateButton.layer.cornerRadius = globalInset - 5;
        rotateButton.contentMode = .center
        rotateButton.isUserInteractionEnabled = true
        addSubview(rotateButton)
        
        let moveGesture = UIPanGestureRecognizer(target: self, action: #selector(ACEDrawingLabelView.moveGesture(_:)))
        addGestureRecognizer(moveGesture)
        
        let singleTapShowHide = UITapGestureRecognizer(target: self, action: #selector(ACEDrawingLabelView.contentTapped))
        addGestureRecognizer(singleTapShowHide)
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(ACEDrawingLabelView.closeTap(_:)))
        closeButton.addGestureRecognizer(closeTap)

        let panRotateGesture = UIPanGestureRecognizer(target: self, action: #selector(ACEDrawingLabelView.rotateViewPanGesture(_:)))
        rotateButton.addGestureRecognizer(panRotateGesture)
        
        moveGesture.require(toFail: closeTap)
        
        
        enableMoveRestriction = false
        enableClose = true
        enableRotate = true
        enableContentShadow = true
        isShowingEditingHandles = true
        labelTextField.becomeFirstResponder()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        border.path = UIBezierPath(rect: labelTextField.bounds).cgPath
        border.frame = labelTextField.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Resizes content to fit rect
    ///
    /// - Parameter rect: New rect will to fit
    func resize(in rect: CGRect) {
        labelTextField.adjustsFontSize(toFill: rect)
    }
}

// MARK: - Gestures actions
extension ACEDrawingLabelView {
    private func estimatedCenter() -> CGPoint {
        guard let superview = self.superview else {
            return CGPoint.zero
        }
        
        var newCenterX = beginningCenter.x + (touchLocation.x - beginningPoint.x);
        var newCenterY = beginningCenter.y + (touchLocation.y - beginningPoint.y);
        
        if enableMoveRestriction {
            if (!(newCenterX - 0.5 * frame.width > 0 &&
                newCenterX + 0.5 * frame.width < superview.bounds.width)) {
                newCenterX = center.x
            }
            if (!(newCenterY - 0.5 * frame.height > 0 &&
                newCenterY + 0.5 * frame.height < superview.bounds.height)) {
                newCenterY = center.y
            }
        }
        return CGPoint(x: newCenterX, y: newCenterY)
    }
    
    func contentTapped() {
        if isShowingEditingHandles {
            superview?.bringSubview(toFront: self)
        }
        isShowingEditingHandles = !isShowingEditingHandles
    }
    
    func closeTap(_ recognizer: UIPanGestureRecognizer) {
        self.removeFromSuperview()
        delegate?.labelViewDidClose(self)
    }
    
    func moveGesture(_ recognizer: UIPanGestureRecognizer) {
        if isShowingEditingHandles == false {
            isShowingEditingHandles = true
        }
        
        touchLocation = recognizer.location(in: superview)
        
        if recognizer.state == .began {
            beginningPoint = touchLocation
            beginningCenter = center
            
            center = estimatedCenter()
            beginBounds = bounds
            
            delegate?.labelViewDidBeginEditing(self)
        } else if recognizer.state == .changed {
            center = estimatedCenter()
            delegate?.labelViewDidChangeEditing(self)
        } else if recognizer.state == .ended {
            center = estimatedCenter()
            delegate?.labelViewDidEndEditing(self)
        }
    }
    
    func rotateViewPanGesture(_ recognizer: UIPanGestureRecognizer) {
        touchLocation = recognizer.location(in: superview)
        
        if recognizer.state == .began {
            deltaAngle = atan2(touchLocation.y - center.y, touchLocation.x - center.x) - transform.angle
            
            initialBounds = bounds
            initialDistance = center.distance(with: touchLocation)
            
            delegate?.labelViewDidBeginEditing(self)
        } else if recognizer.state == .changed {
            let ang = atan2(touchLocation.y - center.y, touchLocation.x - center.x)
            
            let angleDiff = deltaAngle - ang
            transform = CGAffineTransform(rotationAngle: -angleDiff)
            setNeedsDisplay()
            
            //Finding scale between current touchPoint and previous touchPoint
            let scale = sqrt(center.distance(with: touchLocation) / initialDistance)
            let scaleRect = initialBounds.scale(scaleW: scale, scaleH: scale)
            
            if (scaleRect.size.width >= (1 + globalInset * 2 + 20) && scaleRect.size.height >= (1 + globalInset * 2 + 20)) {
                if (fontSize < 100 || scaleRect.width < self.bounds.width) {
                    labelTextField.adjustsFontSize(toFill: scaleRect)
                    bounds = scaleRect
                }
            }
            
            delegate?.labelViewDidChangeEditing(self)
        } else if recognizer.state == .ended {
            delegate?.labelViewDidEndEditing(self)
        }
    }
}

extension ACEDrawingLabelView: UIGestureRecognizerDelegate, UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if isShowingEditingHandles {
            return true
        }
        contentTapped()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.labelViewDidStartEditing(self)
        textField.adjustsWidthToFillItsContents()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if isShowingEditingHandles == false {
            isShowingEditingHandles = true
        }
        textField.adjustsWidthToFillItsContents()
        return true
    }
}


/// MARK: - ACEDrawingLabelViewDelegate
protocol ACEDrawingLabelViewDelegate: NSObjectProtocol {
    
}

extension ACEDrawingLabelViewDelegate {
    /// Occurs when a touch gesture event occurs on close button.
    ///
    /// - Parameter label: A label object informing the delegate about action.
    func labelViewDidClose(_ label: ACEDrawingLabelView) {}
    
    /// Occurs before border and control buttons will show.
    ///
    /// - Parameter label: A label object informing the delegate about showing.
    func labelViewWillShowEditingHandles(_ label: ACEDrawingLabelView) {}
    
    /// Occurs when border and control buttons was shown.
    ///
    /// - Parameter label: A label object informing the delegate about showing.
    func labelViewDidShowEditingHandles(_ label: ACEDrawingLabelView) {}
    
    /// Occurs when border and control buttons was hidden.
    ///
    /// - Parameter label: A label object informing the delegate about hiding.
    func labelViewDidHideEditingHandles(_ label: ACEDrawingLabelView) {}
    
    /// Occurs when label become first responder.
    ///
    /// - Parameter label: A label object informing the delegate about action.
    func labelViewDidStartEditing(_ label: ACEDrawingLabelView) {}
    
    /// Occurs when label starts move or rotate.
    ///
    /// - Parameter label: A label object informing the delegate about action.
    func labelViewDidBeginEditing(_ label: ACEDrawingLabelView) {}
    
    /// Occurs when label continues move or rotate.
    ///
    /// - Parameter label: A label object informing the delegate about action.
    func labelViewDidChangeEditing(_ label: ACEDrawingLabelView) {}
    
    /// Occurs when label ends move or rotate.
    ///
    /// - Parameter label: A label object informing the delegate about action.
    func labelViewDidEndEditing(_ label: ACEDrawingLabelView) {}
}

// MARK: - ACEDrawingLabelViewTransform
class ACEDrawingLabelViewTransform: NSObject {
    let transform: CGAffineTransform
    let center: CGPoint
    let bounds: CGRect
    init(transform: CGAffineTransform, atCenter center: CGPoint, withBounds bounds: CGRect) {
        self.transform = transform
        self.center = center
        self.bounds = bounds
    }
}

// MARK: - Extension

private let ACELVMaximumFontSize = 101
private let ACELVMinimumFontSize = 9
extension UITextField {
    /// Adjust font size to new bounds.
    ///
    /// - Parameter rect: newBounds A new bounds.
    func adjustsFontSize(toFill newBounds: CGRect) {
        guard let text = ((self.text ?? "") != "" || placeholder == nil) ? self.text : placeholder, let font = self.font else {
            return
        }
        
        for i in (ACELVMinimumFontSize...ACELVMaximumFontSize).reversed() {
            let newFont = UIFont(name: font.fontName, size: CGFloat(i))
            
            let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName : newFont as Any])
            
            let rectSize = attributedText.boundingRect(with: CGSize(width: newBounds.width - 24, height: CGFloat.greatestFiniteMagnitude),
                                                       options: .usesLineFragmentOrigin,
                                                       context: nil)
            
            if rectSize.height <= newBounds.height {
                if let drawingLabelView = self.superview as? ACEDrawingLabelView {
                    drawingLabelView.fontSize = CGFloat(i) - 1
                }
                break
            }
        }
    }
    
    /// Adjust width to new text.
    func adjustsWidthToFillItsContents() {
        guard let text = ((self.text ?? "") != "" || placeholder == nil) ? self.text : placeholder, let font = self.font else {
            return
        }
        
        let attributedText = NSAttributedString(string: text, attributes: [NSFontAttributeName : font as Any])
        
        let rectSize = attributedText.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: frame.height - 24),
                                                   options: .usesLineFragmentOrigin,
                                                   context: nil)
        
        let w1 = (ceil(rectSize.size.width) + 24 < 50) ? frame.size.width : ceil(rectSize.size.width) + 24
        let h1 = (ceil(rectSize.size.height) + 24 < 50) ? 50 : ceil(rectSize.size.height) + 24
        
        if let superview = self.superview {
            var viewFrame = superview.bounds
            viewFrame.size.width = w1 + 24
            viewFrame.size.height = h1
            superview.bounds = viewFrame
        }
    }
}

extension CGRect {
    func scale(scaleW: CGFloat, scaleH: CGFloat) -> CGRect {
        return CGRect(x: origin.x * scaleW, y: origin.y * scaleH, width: size.width * scaleW, height: size.height * scaleH)
    }
}

extension CGPoint {
    func distance(with point: CGPoint) -> CGFloat {
        let fx = point.x - x
        let fy = point.y - y
        return sqrt(fx * fx +  fy * fy)
    }
}

extension CGAffineTransform {
    var angle: CGFloat {
        return atan2(b, a)
    }
    
    var scale: CGSize {
        return CGSize(width: sqrt(a * a + c * c), height: sqrt(b * b + d * d))
    }
}
