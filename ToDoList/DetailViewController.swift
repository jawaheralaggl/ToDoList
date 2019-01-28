//
//  ToDoViewController.swift
//  ToDoList
//
//  Created by Simon Italia on 6/5/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UITextViewDelegate {
    
    //Store a created ToDo object
    var todo: ToDo?
    
    //Set a variable for determining if Date picker is hidden
    var isDueDatePickerHidden = true
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePickerView: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set DetailVC as delegate of UITextView to respond to changes
        notesTextView.delegate = self
        
        //Get Saved Button State on DetailVC load
        updateSaveButtonState()
        
        //Show ToDo Object / List data when user clicks from Main List Dynamic (ToDo) Table view
        if let todo = todo {
            navigationItem.title = "Edit To-Do item"
            titleTextField.text = todo.title
            isCompleteButton.isSelected = todo.isComplete
            dueDatePickerView.date = todo.dueDate
            updateDueDateLabel(date: dueDatePickerView.date)
            notesTextView.text = todo.notes
            
            if notesTextView.text == "<Additional notes>" {
                notesTextView.textColor = UIColor.lightGray
                notesTextView.font = UIFont(name: "verdana", size: 13.0)
            }
        
        //Set title and fields to new ToDo item
        } else {
            navigationItem.title = "New To-Do item"
            dueDatePickerView.date =
                Date().addingTimeInterval(24*60*60)
            updateDueDateLabel(date: dueDatePickerView.date)
            notesTextView.text = "<Additional notes>"
            notesTextView.textColor = UIColor.lightGray
            notesTextView.font = UIFont(name: "verdana", size: 13.0)
        }
        
    } //End viewDidLoad() Method
    
    //Method to detect inputs into UITextField, and update Save button accordingly
    @IBAction func textFieldEdited(_ sender: UITextField) {
            updateSaveButtonState()
    }
    
    //Update Due Date Label with Date entered from Date picker
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = ToDo.dueDateFormatter.string(from: date)
    }
    
    //Detect when user edits text in TextView (this method is built in, provided by UITextViewDelegate() protocol)
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        updateSaveButtonState()
    }
    
    //Dismiss Keyboard when Return key is pressed in text field
    @IBAction func returnPressed(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    
    //Toggle completed button image from unchecked / hollow image to checked image
    @IBAction func isCompletedButtonTapped(_ sender: UIButton) {
        isCompleteButton.isSelected = !isCompleteButton.isSelected
        updateSaveButtonState()
    }
    
    //Update the Due Date label as the Date Picker changes
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        updateDueDateLabel(date: dueDatePickerView.date)
        updateSaveButtonState()
    }
    
    //Expand and collapse Date Picker section (1) and row (0) using the table index Path
    override func tableView(_ tableView: UITableView, heightForRowAt
        indexPath: IndexPath) -> CGFloat {
        let normalCellHeight = CGFloat(44) //Cell height when date pikcer is not shown
        let largeCellHeight = CGFloat(200) //Cell height when date pikcer is shown
        
        switch(indexPath) {
            //Due Date Table Cell/Row
            //(Old code): return isDueDatePickerHidden ? normalCellHeight : largeCellHeight
            
        case [1,0]: //section (index) 1, actual section is 2, row (index) 0, actual row is 1 of Table View where Due Date label resides
            if isDueDatePickerHidden == true {
                return normalCellHeight
            } else {
                return largeCellHeight
            }
            
        //Notes Table Cell/Row
        case [2,0]:
            return largeCellHeight
            
        //Default case
        default: return normalCellHeight
        }
    }
    
    //Respond to user tapping due date label to trigger expanding Date Picker
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath) {
        case [1,0]:
            isDueDatePickerHidden = !isDueDatePickerHidden
            
            dueDateLabel.textColor = isDueDatePickerHidden ? .black : tableView.tintColor
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default: break
        }
    }
    
    //UITextView delegate methods to respond to user edits
    
    //Detect if user begins editing inside UITextView
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "<Additional notes>" {
            textView.text = ""
            textView.textColor = UIColor.black
            textView.font = UIFont(name: "verdana", size: 18.0)
        }
    }
    
//    //Detected if UITextView text is empty when user finishes editing to add in default text
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == "" {
//            textView.text = "<Additional notes>"
//            textView.textColor = UIColor.lightGray
//            textView.font = UIFont(name: "verdana", size: 13.0)
//        }
//    }
    
    //Pass data from Static (New ToDo) Table View to Dynamic (ToDo) Table View with prepare for sender function
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        //Set values for ToDo data model (Struc) properties
        let titleText = titleTextField.text!
        let isComplete = isCompleteButton.isSelected
        let dueDate = dueDatePickerView.date
        let notes = notesTextView.text
        
        //todo var declared at top of class. Create a todo object
        todo = ToDo(title: titleText, isComplete: isComplete, dueDate:
            dueDate, notes: notes)
    }
    
    //Update Save Button method based on text present or not in Text field
    func updateSaveButtonState() {
        let titleText = titleTextField.text ?? ""
        saveButton.isEnabled = !titleText.isEmpty
    }
}
