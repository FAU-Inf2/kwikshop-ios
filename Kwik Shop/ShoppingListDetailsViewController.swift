//
//  ShoppingListDetailsViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 08.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ShoppingListDetailsViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    
    var shoppingList : ShoppingList?
    var newList = true
    
    override var hidesBottomBarWhenPushed : Bool {
        get {
            return true
        }
        set {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        // Do any additional setup after loading the view.
        if (newList) {
            toolbar.hidden = true
            doneButton.enabled = false
        } else if let list = shoppingList {
            nameTextField.text = list.name
            self.title = list.name
        }
        
        // close keyboard when user taps on the view
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "closeKeyboard")
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(animated: Bool) {
        if newList {
            nameTextField.becomeFirstResponder()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    func checkValidName(text : String) {
        // Disable the Save button if the text field is empty.
        doneButton.enabled = !text.isEmpty
    }

    func closeKeyboard() {
        nameTextField.resignFirstResponder()
    }

    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        //if (textField === nameTextField) {
            checkValidName(textField.text!)
            navigationItem.title = textField.text
        //}
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        //if (textField === nameTextField) {
            let text = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
            checkValidName(text)
            return true
        //}
    }
    
    
    // MARK: - Navigation

    @IBAction func cancel(sender: UIBarButtonItem) {
        if newList {
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            navigationController!.popViewControllerAnimated(true)
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        // if a confirmation dialoge should be displayed before the item is deleted: here is the place to do so
        if sender === deleteButton {            
            let alert = DeleteConfirmationAlertHelper.getDeleteConfirmationAlertWithDeleteHandler(
                { [unowned self, weak deleteButton = self.deleteButton] (action: UIAlertAction!) in
                    self.performSegueWithIdentifier("unwindToListOfShoppingLists", sender: deleteButton)
                },
                forASingularValue: true)
            
            alert.popoverPresentationController?.barButtonItem = deleteButton
            presentViewController(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }

    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender === deleteButton {
            shoppingList = nil
        } else {
            if newList {
                shoppingList = ShoppingList(name: nameTextField.text!)
            } else {
                shoppingList!.name = nameTextField.text!
            }
        }
        
    }

}
