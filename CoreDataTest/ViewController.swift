//
//  ViewController.swift
//  CoreDataTest
//
//  Created by Pedro Ésli Vieira do Nascimento on 08/10/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var datepicker: UIDatePicker!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var pickedDate: Date?
    var peDate: PEDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        
        pickedDate = datepicker.date
        fetchGlucoseLevels()
    }

    @IBAction func addButtonPressed(_ sender: UIButton) {
        presentAlert(message: "Insert glucose level", buttonTitle: "Add") { text in
            guard let text = text else {
                return
            }
            guard let glucoseLevel = Int(text) else{
                return
            }
            self.saveGlucoseLevel(glucoseLevel)
        }
    }
    
    func presentAlert(message: String, inputText: String? = nil, buttonTitle: String, complitionHandler: @escaping (String?) -> Void){
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        
        alert.addTextField { textField in
            if let text = inputText {
                textField.text = text
            }
            textField.keyboardType = .numberPad
        }
        
        //Ok
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { action in
            guard let text = alert.textFields?.first?.text else{
                return
            }
            complitionHandler(text)
        }))
        
        //Cancel
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            complitionHandler(nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        peDate = nil //reset peDate
        pickedDate = sender.date
        fetchGlucoseLevels()
    }
    
    @IBAction func todayButtonPressed(_ sender: UIButton){
        datepicker.setDate(Date(), animated: true)
        pickedDate = datepicker.date
        fetchGlucoseLevels()
    }
    
    func saveGlucoseLevel(_ glucoseLevel: Int){
        let glucose = Glucose(context: context)
        glucose.level = Int64(glucoseLevel)
        glucose.timeRegistered = Date()
        
        if peDate == nil{
            let components = Calendar.current.dateComponents([.day,.month,.year], from: pickedDate!)
            guard let day = components.day,
                  let month = components.month,
                  let year = components.year else{
                return
            }
            peDate = PEDate(context: context)
            peDate?.day = Int64(day)
            peDate?.month = Int64(month)
            peDate?.year = Int64(year)
        }
        peDate?.insertIntoGlucoseLevels(glucose, at: 0)
        
        do{
            try context.save()
        }
        catch{
            print(error.localizedDescription)
        }
        tableview.beginUpdates()
        tableview.insertRows(at: [IndexPath(row: 0 , section: 0)], with: .middle)
        tableview.endUpdates()
    }
    
    func fetchGlucoseLevels(){
        let components = Calendar.current.dateComponents([.day,.month,.year], from: pickedDate!)
        guard let day = components.day,
              let month = components.month,
              let year = components.year else{
            return
        }
        
        let fetchRequest = PEDate.fetchRequest()
        let dayPredicate = NSPredicate(format: "day == %i", day)
        let monthPredicate = NSPredicate(format: "month == %i", month)
        let yearPredicate = NSPredicate(format: "year == %i", year)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [dayPredicate, monthPredicate, yearPredicate])
        
        do{
            let result = try context.fetch(fetchRequest)
            guard let peDate = result.first else{
                reloadTableData()
                return
            }
            self.peDate = peDate
            reloadTableData()
        }
        catch{
            print(error.localizedDescription)
            reloadTableData()
            return
        }
    }
    
    func deleteGlucoseLevel(at indexPath: IndexPath){
        guard let peDate = self.peDate else{
            return
        }
        
        peDate.removeFromGlucoseLevels(at: indexPath.row)
        do{
            try context.save()
            //reloadTableData()
        }
        catch{
            print(error.localizedDescription)
        }
        
        tableview.beginUpdates()
        tableview.deleteRows(at: [indexPath], with: .automatic)
        tableview.endUpdates()
    }
    
    func reloadTableData(){
        DispatchQueue.main.async {
            self.tableview.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peDate?.glucoseLevels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        if let glucose = peDate?.glucoseLevels?.array[indexPath.row] as? Glucose {
            let dateFormater = DateFormatter()
            dateFormater.timeStyle = .short
            content.text = "\(glucose.level)"
            content.secondaryText = dateFormater.string(from: glucose.timeRegistered!)
            cell.contentConfiguration = content
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Edit action
        let edit = UIContextualAction(style: .normal, title: "") { [weak self] action, view, completionHandler in
            
            guard let glucose = self?.peDate?.glucoseLevels?.array[indexPath.row] as? Glucose else{
                return
            }
            
            self?.presentAlert(message: "Edit glucose level", inputText: "\(glucose.level)", buttonTitle: "Edit") { text in
                guard let text = text else{
                    completionHandler(true)
                    return
                }
                guard let level = Int64(text) else {
                    return
                }
                glucose.level = level
                do{
                    try self?.context.save()
                    completionHandler(true)
                    self?.reloadTableData()
                }
                catch{
                    print(error)
                }
            }
        }
        edit.backgroundColor = UIColor.systemCyan
        let config = UIImage.SymbolConfiguration(pointSize: 22)
        edit.image = UIImage(systemName: "pencil.circle.fill", withConfiguration: config)
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Delete action
        let delete = UIContextualAction(style: .destructive, title: "") { [weak self] action, view, completionHandler in
            self?.deleteGlucoseLevel(at: indexPath)
            completionHandler(true)
        }
        let config = UIImage.SymbolConfiguration(pointSize: 22)
        delete.image = UIImage(systemName: "trash.fill", withConfiguration: config)
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


