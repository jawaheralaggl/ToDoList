//
//  ToDo.swift
//  ToDoList
//
//  Created by Simon Italia on 6/4/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

//ToDo List Model, properties. Codable allows the strcu data to encode and decode data for saving and retrieving from disk
struct ToDo: Codable {
    var title: String
    var isComplete: Bool
    var dueDate: Date
    var notes: String?
    
    //Create an initial structure object
    /*static func loadToDos() -> [ToDo]?  {
        return nil
    }

    //create initial structure object with following "sample" property values/data
    static func loadSampleToDos() -> [ToDo] {
        let todo1 = ToDo(title: "ToDo One", isComplete: false, dueDate: Date(), notes: "Notes 1")
        let todo2 = ToDo(title: "ToDo Two", isComplete: false, dueDate: Date(), notes: "Notes 2")
        let todo3 = ToDo(title: "ToDo Three", isComplete: false, dueDate: Date(), notes: "Notes 3")
        return [todo1, todo2, todo3]
    }*/
    
    //File location for saving / reading data entered in the app
    static let DocumentsDirectory =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("todos")
        .appendingPathExtension("plist")
    
    //This method saves app data to disk
    static func saveToDos(_ todos: [ToDo]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedToDos = try? propertyListEncoder.encode(todos)
        try? codedToDos?.write(to: ArchiveURL, options: .noFileProtection)
    }
    
    //This method loads the saved data from disk
    static func loadToDos() -> [ToDo]?  {
        guard let codedToDos = try? Data(contentsOf: ArchiveURL)
            else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<ToDo>.self, from: codedToDos)
    }
    
    //Date formatter Object
    static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
            //will set date to shortest possible string
        formatter.timeStyle = .short
            //will set time to shortest possible string
        return formatter
        }()

}

