//
//  ViewController.swift
//  ACEDrawingView
//
//  Created by LiuYanghui on 2017/5/8.
//  Copyright © 2017年 Yanghui.Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let label = ACEDrawingLabelView(frame: CGRect(x: 100, y: 100, width: 50, height: 100))
        label.textValue = "写点什么吧"
        label.delegate = self
        label.fontSize     = 18.0;
        label.fontName     = UIFont.systemFont(ofSize: 18).fontName
        label.textColor    = .black
        label.closeImage   = #imageLiteral(resourceName: "sticker_close")
        label.rotateImage  = #imageLiteral(resourceName: "sticker_resize")
        view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ACEDrawingLabelViewDelegate {
    
}

