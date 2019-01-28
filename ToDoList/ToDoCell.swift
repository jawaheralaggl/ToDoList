//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Simon Italia on 6/12/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

//Protcol to pass the cell back to the designated delegate class. The delegate is the ToDoTableViewController class
@objc protocol ToDoCellDelegate: class {
    
    func completeButtonTapped(sender: ToDoCell)
}

class ToDoCell: UITableViewCell {
    
    //Delegate property
    var delegate: ToDoCellDelegate?
    
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func isCompleteButtonTapped() {
        delegate?.completeButtonTapped(sender: self)
        //This informs the delegate (which is the TableViewController) the button has been tapped, passing self as the parameter
    }
}
