//
//  DeleteConfirmationAlert.swift
//  Kwik Shop
//
//  Created by Adrian Kretschmer on 27.08.15.
//  Copyright (c) 2015 FAU-Inf2. All rights reserved.
//

import UIKit

class DeleteConfirmationAlertHelper {
       
    static func getDeleteConfirmationAlertWithDeleteHandler(deleteHandler: ((UIAlertAction!) -> Void)?, forASingularValue singular: Bool) -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let deleteTitle = singular ? "alert_box_delete".localized : "alert_box_delete_plural".localized
        alert.addAction(UIAlertAction(title: deleteTitle, style: .Destructive, handler: deleteHandler))
        
        /*alert.addAction(UIAlertAction(title: "Delete and don't ask again", style: .Default, handler: { [unowned self, weak deleteButton = self.deleteButton] (action: UIAlertAction!) in
            // TODO: Perform logic to avoid asking again
            }))*/
        
        alert.addAction(UIAlertAction(title: "alert_box_cancel".localized, style: .Cancel, handler: nil))

        return alert
    }
    
}
