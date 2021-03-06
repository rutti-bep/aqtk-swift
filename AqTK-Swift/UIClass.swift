//
//  UIClass.swift
//  AqTK-Swift
//
//  Created by 今野暁 on 2017/03/15.
//  Copyright © 2017年 SK. All rights reserved.
//
import Cocoa
import Foundation
import AppKit

class SuperButton: NSButton {
    func create(title:String? = nil,x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,action:Selector? = nil,target:AnyObject? = nil){
        self.frame = NSRect(x:x,y:y,width:width,height:height)
        if (title != nil){
            self.title = title!
        }
        if (target != nil){
            self.target = target
        }
        self.action = action
    }
    
    var backgroundColor: NSColor {
        get {
            return (self.cell as! NSButtonCell).backgroundColor!
        }
        
        set {
            (self.cell as! NSButtonCell).backgroundColor = newValue
        }
    }
}

class Label: NSTextField {
    var text: String {
        get {
            return self.placeholderString!
        }
        
        set {
            self.placeholderString = newValue        }
    }
    
    func create(x:CGFloat,y:CGFloat,width:CGFloat,height:CGFloat,defaultText:String){
        self.frame = NSRect(x:x,y:y,width:width,height:height);
        self.placeholderString = defaultText;
        self.allowsEditingTextAttributes = false;
        self.drawsBackground = false;
        self.isBordered = false;
        self.isEditable = false;
        self.isSelectable = false;
    }
}
