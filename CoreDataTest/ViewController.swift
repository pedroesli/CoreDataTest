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
        let alert = UIAlertController(title: "", message: "Insert glucose level", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "100"
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [self] action in
            guard let text = alert.textFields?.first?.text else{
                return
            }
            
            guard let glucoseLevel = Int(text) else{
                return
            }
            
            self.saveGlucoseLevel(glucoseLevel)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
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
        tableview.deleteRows(at: [indexPath], with: .bottom)
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //Delete action
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, view, completionHandler in
            self?.deleteGlucoseLevel(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


