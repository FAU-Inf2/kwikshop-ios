//
//  ItemDetailsPickerViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 03.09.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class ItemDetailsPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    
    var isAmountAndUnitPicker : Bool!
    var groupDelegate : GroupDelegate!
    var amountAndUnitDelegate : AmountAndUnitDelegate!
    
    var currentAmount: Int?
    var currentUnit: Unit?
    var currentGroup: Group?
    
    private var unitHasChanged = false
    private var groupHasChanged = false
    
    private let AMOUNT_COMPONENT = AmountAndUnitDelegate.AMOUNT_COMPONENT
    private let UNIT_COMPONENT = AmountAndUnitDelegate.UNIT_COMPONENT
    private let GROUP_COMPONENT = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isAmountAndUnitPicker! {
            amountAndUnitDelegate = AmountAndUnitDelegate()
            pickerView.delegate = self
            pickerView.dataSource = self
            
            amountAndUnitDelegate.selectAmount(currentAmount, andUnit: currentUnit!, forPickerView: pickerView, animated: false)
        } else {
            groupDelegate = GroupDelegate()
            pickerView.delegate = self
            pickerView.dataSource = self
            if let row = find(groupDelegate.data, currentGroup!) {
                pickerView.selectRow(row, inComponent: GROUP_COMPONENT, animated: false)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool) {
        if let itemDetailsViewController = self.navigationController?.topViewController as? ItemDetailsViewController {
            // Returning to item details
            if isAmountAndUnitPicker! {
                itemDetailsViewController.currentAmount = currentAmount
                itemDetailsViewController.currentUnit = currentUnit!
                itemDetailsViewController.unitHasChanged = unitHasChanged
            } else {
                itemDetailsViewController.currentGroup = currentGroup!
                itemDetailsViewController.groupHasChanged = groupHasChanged
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: PickerView Delegate and Data Source
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        let delegate : UIPickerViewDataSource
        if isAmountAndUnitPicker! {
            delegate = amountAndUnitDelegate
        } else {
            delegate = groupDelegate
        }
        return delegate.numberOfComponentsInPickerView(pickerView)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let delegate : UIPickerViewDataSource
        if isAmountAndUnitPicker! {
            delegate = amountAndUnitDelegate
        } else {
            delegate = groupDelegate
        }
        return delegate.pickerView(pickerView, numberOfRowsInComponent: component)
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let delegate : UIPickerViewDelegate
        if isAmountAndUnitPicker! {
            delegate = amountAndUnitDelegate
        } else {
            delegate = groupDelegate
        }
        return delegate.pickerView?(pickerView, titleForRow: row, forComponent: component)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let delegate : UIPickerViewDelegate
        if isAmountAndUnitPicker! {
            delegate = amountAndUnitDelegate
            if component == UNIT_COMPONENT {
                unitHasChanged = true
                currentUnit = amountAndUnitDelegate.unitData[row]
            } else {
                let amounts = currentUnit!.allowedPickerAmounts
                currentAmount = amounts[row]
            }
        } else {
            delegate = groupDelegate
            groupHasChanged = true
            currentGroup = groupDelegate.data[row]
        }
        delegate.pickerView?(pickerView, didSelectRow: row, inComponent: component)
        if isAmountAndUnitPicker! {
            if component == UNIT_COMPONENT {
                currentAmount = amountAndUnitDelegate.getSelectedAmount()
            }
        }
    }
}
