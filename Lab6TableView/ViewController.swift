import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var todoTableView: UITableView!
    var todo: [String] = []
    
    // This function sets up the list of tasks
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTableView.dataSource = self
        todoTableView.delegate = self
        // To save data in  permanent storage
        if let savedTodo = UserDefaults.standard.array(forKey: "todoList") as? [String] {
            todo = savedTodo
        }
    }
    // This function adds a new task to the to-do list when the user taps the "OK" button.
    @IBAction func addButton(_ sender: UIButton) {
        // Pop Up window for user Input
        let alert = UIAlertController(title: "ToDoList", message: "Please Enter Task You want add in ToDoList: ", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter a Task: "
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0]
            self.todo.append(textField!.text!)
            self.todoTableView.beginUpdates()
            self.todoTableView.insertRows(at: [IndexPath(row: self.todo.count-1, section: 0)], with: .automatic)
            self.todoTableView.endUpdates()
            
            // Store the updated todo list in permanent storage
            UserDefaults.standard.set(self.todo, forKey: "todoList")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: {[weak alert](_) in
            alert?.dismiss(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    // This function creates and configures a cell to display a to-do item.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel?.text = todo[indexPath.row]
        return cell
    }
    // This function handles the deletion of a to-do item from the list.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todo.remove(at: indexPath.row)
            todoTableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Store the updated todo list in in permanent storage
            UserDefaults.standard.set(todo, forKey: "todoList")
        }
    }

}
