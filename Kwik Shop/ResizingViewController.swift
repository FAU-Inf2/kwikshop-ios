//
//  ResizingViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 31.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ResizingViewController: UIViewController {

    @IBOutlet weak var bottomViewLayoutConstraint: NSLayoutConstraint!
    var bottomViewLayoutConstraintDefaultConstant : CGFloat!
    var bottomViewLayoutConstraintKeyboardOpenOffset : CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.bottomViewLayoutConstraint.constant = (bottomViewLayoutConstraintKeyboardOpenOffset ?? bottomViewLayoutConstraintDefaultConstant) + keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
            self.bottomViewLayoutConstraint.constant = bottomViewLayoutConstraintDefaultConstant
        }
    }
}
