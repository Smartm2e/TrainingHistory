//
//  MainTableViewController.swift
//  TrainingHistory
//
//  Created by Smartm2e on 2020/9/5.
//  Copyright © 2020 Smartm2e. All rights reserved.
//

import UIKit
import CoreData

class MainTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedRow = 0

    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // 载入已有数据
        do {
            trainings = try context.fetch(Training.fetchRequest())
        } catch {
            print("未读取到已存储数据")
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return trainings.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingCell", for: indexPath)

        cell.textLabel?.text = trainings[indexPath.row].sportName
        guard let date = trainings[indexPath.row].date else {
            fatalError("未能获取到日期信息")
        }
        
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd'T'HH:mm")
//        dateFormatter.timeStyle = .short
//        dateFormatter.dateStyle = .medium
        let dateString = dateFormatter.string(from: date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            context.delete(trainings[indexPath.row])
            trainings.remove(at: indexPath.row)
            
            saveData()
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    @IBAction func count(_ sender: UIBarButtonItem) {
        let count = trainings.count
        let ac = UIAlertController(title: "统计", message: "当前共有\(count)条运动记录。", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "好的", style: .default))
        present(ac, animated: true)
    }
    
    // MARK: - Navigation

    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "addTraining" {
            let vc = segue.destination as! TrainingViewController
            vc.delegate = self
        } else if segue.identifier == "showTraining" {
            let vc = segue.destination as! TrainingViewController
            vc.title = "查看训练记录"
            // 点击查询时，先确定点击的row，将值传给vc，然后将vc内textField置于不可编辑的状态
            selectedRow = tableView.indexPathForSelectedRow!.row
            
            let selectedTraining = trainings[selectedRow]
            
            // 传值
            vc.selectedSportName = String(selectedTraining.sportName!)
            vc.selectedDate = String(dateFormatter.string(from: selectedTraining.date!))
            vc.selectedDuration = String(selectedTraining.duration)
            vc.selectedDistance = String(selectedTraining.distance)
            
            vc.delegate = self
        }
    }
    
    
    
}


extension MainTableViewController: AddTrainDelegate {
    
    func didAdd(sportName: String, date: Date, duration: Int16, distance: Double) {
        let newTrain = Training(context: context)
        
        newTrain.sportName = sportName
        newTrain.date = date
        newTrain.duration = duration
        newTrain.distance = distance
        
        
        trainings.insert(newTrain, at: 0)
        
        saveData()
        
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        // 汉化删除按钮
        return "删除"
    }
}
