//
//  AutoCompletionViewController.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 24.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class AutoCompletionViewController: ResizingViewController {
    
    private var autoCompleteTextFields = [MLPAutoCompleteTextField]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeAutoCompletionTextField(textField: MLPAutoCompleteTextField, withDataSource dataSource: MLPAutoCompleteTextFieldDataSource) {
        if !contains(autoCompleteTextFields, textField) {
            autoCompleteTextFields.append(textField)
        }
        textField.autoCompleteDataSource = dataSource
        textField.autoCompleteTableBackgroundColor = UIColor.whiteColor()
        textField.showAutoCompleteTableWhenEditingBegins = true
        
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation == .LandscapeLeft || orientation == .LandscapeRight {
            textField.maximumNumberOfAutoCompleteRows = 3
        } else {
            textField.maximumNumberOfAutoCompleteRows = 5
        }
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
       
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        coordinator.animateAlongsideTransition(
            { [unowned self] (context) -> () in
                let orientation = UIApplication.sharedApplication().statusBarOrientation
                let maximumNumberOfAutoCompleteRows : Int
                if orientation.isLandscape {
                    maximumNumberOfAutoCompleteRows = 3
                    
                } else {
                    maximumNumberOfAutoCompleteRows = 5
                }
                for textField in self.autoCompleteTextFields {
                    textField.maximumNumberOfAutoCompleteRows = maximumNumberOfAutoCompleteRows
                    textField.autoCompleteTableViewHidden = true
                }
            },
            completion: { [unowned self] (context) -> () in
                for textField in self.autoCompleteTextFields {
                    textField.autoCompleteTableViewHidden = false
                }
            })
    }
}
