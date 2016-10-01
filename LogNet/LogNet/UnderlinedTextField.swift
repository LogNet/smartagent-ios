//
//  UnderlinedTextField.swift
//  SmartAgent
//
//  Created by Anton Tikhonov on 7/18/16.
//  Copyright © 2016 Anton Tikhonov. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {
    let lineColor = UIColor(red: 0.0, green: 122.0/255, blue: 255.0/255.0, alpha: 1)
    var underline:UIView?
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addUnderline(self.frame)
       
    }
    
    /*
     override func drawRect(rect: CGRect) {
     // Drawing code
     
     }*/
    
    // MARK: Methods
    
    func addUnderline(frame: CGRect) {
        let x = 0.0 as CGFloat
        let height = 0.5 as CGFloat
        let width = frame.size.width
        let y = frame.size.height - height
        let rect = CGRectMake(x, y, width, height)
        self.underline = UIView(frame: rect)
        self.underline!.backgroundColor = self.lineColor
        self.addSubview(self.underline!)
    }
    
    func setUnderlineHeight(height height:CGFloat) {
        var frame = self.underline!.frame
        frame.size.height = height
        frame.origin.y = self.frame.size.height - height
        self.underline?.frame = frame
    }
    
    override func becomeFirstResponder() -> Bool {
        self.setUnderlineHeight(height: 1.9)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        self.setUnderlineHeight(height: 0.5)
        return super.resignFirstResponder()
    }

}
