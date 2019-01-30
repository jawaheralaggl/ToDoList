//
//  TableViewController.swift
//  ToDoList
//
//  Created by Simon Italia on 6/4/18.
//  Copyright © 2018 SDI Group Inc. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate, ToDoCellDelegate {
    
    //Creates an empty array called ToDo
    var todos = [ToDo]()
    
    //Search Bar properties
    let searchController = UISearchController(searchResultsController: nil)
    var isSearching = false
    var searchResults = [Int]()
    
    @IBOutlet weak var cellLabel: UILabel!
    
    //Add a new ToDo object to Table collection if an new ToDo object was created and being passed in by the ToDo Table View
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! DetailViewController
        
        //This will either update an existing ToDo Object on the ToDo Table View if one was edited, or create a new ToDo Object and add an entry at the bottom of the ToDo Table View
        if let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            
            } else {
                //Determine index path / row to add the new ToDo object to
                    let newIndexPath = IndexPath(row: todos.count, section: 0)
                    todos.append(todo)
                    tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        
        ToDo.saveToDos(todos)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set Title
        title = "To-Do List"
        
        //Setup Edit rows button on navigation bar
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
            //this property ensures any VCs displayed from this viewController can navigate back
        
        //Display the Search controller
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search list"
        searchController.searchBar.sizeToFit()
        
        //Load any saved data from disk
        if let savedToDos = ToDo.loadToDos() {
            todos = savedToDos
        } else {
            return
        }
        
    } //End viewDidLoad() method
    
    //Return each cell object (to do item) to the front end
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return todos.count
        
        //Restun table rows depending on if a search is being performed or not
        return isSearching ? searchResults.count : todos.count
    }
    
    //This method is called whenever a cell is about to be displayed onscreen, and the method provides you the IndexPath that you'll use to determine which cell you're dealing with
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {fatalError("Could not dequeue cell")}
        
        //When the cell is called by the delegate
        cell.delegate = self
        
        //Dispaly ToDo title in the cell row
//        let todo = todos[indexPath.row]
        
//        cell.textLabel?.text = todo.title
//        cell.titleLabel?.text = todo.title
//        cell.isCompleteButton.isSelected = todo.isComplete
        
        let todo: ToDo
        let row = indexPath.row
        
        //Show all ToDo items in tableView
        if isSearching == false {
            todo = todos[row]
            cell.titleLabel?.text = todo.title
            cell.isCompleteButton.isSelected = todo.isComplete
        
        //Show filtered, search results ToDo items in tableView
        } else {
            todo = todos[searchResults[row]]
            cell.titleLabel?.text = todo.title
            cell.isCompleteButton.isSelected = todo.isComplete
        }
        
        return cell
    
    }//End of cellForRowAt() method

    override func tableView(_ tableView: UITableView, canEditRowAt
        indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit
        editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath:
        IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveToDos(todos)
        }
    }
    
    //Pass a ToDo object in the ToDo Dynamic Table View on push to Static NewToDo Table View, when user clicks on an exitsing ToDo Object/item. Don't forget to then update the static New Tod Do Table view to receive/display the Object on load 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
                //set in atrributes inspector of Show segue
            
            let todoViewController = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedTodo = todos[indexPath.row]
            todoViewController.todo = selectedTodo
        }
    }
    
    //Determine index path of the cell to update the checkmark when set by the delegate pathway
    func completeButtonTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            var todo = todos[indexPath.row]
            todo.isComplete = !todo.isComplete
            todos[indexPath.row] = todo
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveToDos(todos)
        }
    }
    
    //UISearchResultsUpdating protocol methods
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
            searchResults.removeAll()
            
            //Store ToDo titles in new array to use for keyword search
            var todoTitles = [String]()
            
            for todo in todos {
                let todoTitle = todo.title
                todoTitles.append(todoTitle)
            }
            
            //Store the index of ToDo titles matching keyword search in index array
            for index in 0..<todos.count {
                if todoTitles[index].lowercased().contains(
                    searchText.lowercased()) {
                    searchResults.append(index)
                }
            }

            isSearching = true
        
        } else {
            isSearching = false
        }
        
        tableView.reloadData()
        
    } //End updateSearchResults() method
}
