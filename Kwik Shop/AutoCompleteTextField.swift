//
//  AutoCompleteTextField.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 21.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import Foundation


class AutoCompleteTextField: MLPAutoCompleteTextField, MLPAutoCompleteTextFieldDelegate {
    
    private var privateDelegate : MLPAutoCompleteTextFieldDelegate?
    
    override var autoCompleteDelegate : MLPAutoCompleteTextFieldDelegate! {
        set {
            if newValue !== self {
                privateDelegate = newValue
            } else {
                privateDelegate = nil
            }
        }
        get {
            return super.autoCompleteDelegate
        }
    }
    
    private var allowResignFirstResponder = true
    
    override func canResignFirstResponder() -> Bool {
        if allowResignFirstResponder {
            return true
        }
        allowResignFirstResponder = true
        return false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        super.autoCompleteDelegate = self
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.autoCompleteDelegate = self
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField, didSelectAutoCompleteString selectedString: String, withAutoCompleteObject selectedObject: MLPAutoCompletionObject, forRowAtIndexPath indexPath: NSIndexPath) {
        if privateDelegate != nil {
            privateDelegate?.autoCompleteTextField?(textField, didSelectAutoCompleteString: selectedString, withAutoCompleteObject: selectedObject, forRowAtIndexPath: indexPath)
        }
        self.delegate?.textFieldDidEndEditing?(self)
        allowResignFirstResponder = false
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, shouldConfigureCell cell: UITableViewCell!, withAutoCompleteString autocompleteString: String!, withAttributedString boldedString: NSAttributedString!, forAutoCompleteObject autocompleteObject: MLPAutoCompletionObject!, forRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        if privateDelegate != nil {
            return privateDelegate!.autoCompleteTextField!(textField, shouldConfigureCell: cell, withAutoCompleteString: autocompleteString, withAttributedString: boldedString, forAutoCompleteObject: autocompleteObject, forRowAtIndexPath: indexPath)
        }
        return true
    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, shouldStyleAutoCompleteTableView autoCompleteTableView: UITableView!, forBorderStyle borderStyle: UITextBorderStyle) -> Bool {
        if privateDelegate != nil {
            return privateDelegate!.autoCompleteTextField!(textField, shouldStyleAutoCompleteTableView: autoCompleteTableView, forBorderStyle: borderStyle)
        }
        return true

    }
    
    func autoCompleteTextField(textField: MLPAutoCompleteTextField!, willShowAutoCompleteTableView autoCompleteTableView: UITableView!) {
        if privateDelegate != nil {
            privateDelegate?.autoCompleteTextField?(textField, willShowAutoCompleteTableView: autoCompleteTableView)
        }
    }
}