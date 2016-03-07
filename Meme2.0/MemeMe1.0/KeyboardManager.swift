//
//  KeyboardManager.swift
//  MemeMe
//
//  Created by Max Sokolov on 27/06/15.
//  Copyright (c) 2015 Max Sokolov. All rights reserved.
//

import Foundation
import UIKit

protocol KeyboardManagerDelegate : NSObjectProtocol {

    func keyboardWillShow(keyboardHeight: CGFloat)
    func keyboardWillHide()
}

/*!
    An easy to use keyboard manager. We don't need to worry about subscription and unsubscription for keyboard events.
*/
class KeyboardManager : NSObject {

    weak var delegate : KeyboardManagerDelegate?
    
    override init() {
        super.init()
        
        subscribeToKeyboardNotifications()
    }
    
    deinit {

        unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        delegate?.keyboardWillShow(getKeyboardHeight(notification))
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        delegate?.keyboardWillHide()
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    private func subscribeToKeyboardNotifications() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
}