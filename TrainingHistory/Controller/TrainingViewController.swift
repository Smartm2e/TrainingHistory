//
//  TrainingViewController.swift
//  TrainingHistory
//
//  Created by Smartm2e on 2020/9/5.
//  Copyright © 2020 Smartm2e. All rights reserved.
//

import UIKit

protocol AddTrainDelegate {
    func didAdd(sportName: String, date: Date, duration: Int16, distance: Double)
}

class TrainingViewController: UIViewController {
    @IBOutlet weak var sportNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    @IBOutlet weak var addTrainBtn: UIBarButtonItem!

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackViewCenterConstraint: NSLayoutConstraint!
    
    var selectedSportName: String?
    var selectedDate: String?
    var selectedDuration: String?
    var selectedDistance: String?
    
    let dateFormatter = DateFormatter()
    
    var delegate: AddTrainDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 获取当前时间填入“时间”项目内
        dateFormatter.locale = Locale(identifier: "zh_CN")
        dateFormatter.setLocalizedDateFormatFromTemplate("yyyy-MM-dd'T'HH:mm")
        
        if selectedDistance != nil, selectedDuration != nil, selectedDate != nil, selectedSportName != nil {
            // 如果是查询，就不需要添加按钮
            addTrainBtn.isEnabled = false
            
            sportNameTextField.text = selectedSportName
            dateTextField.text = selectedDate
            durationTextField.text = selectedDuration
            distanceTextField.text = selectedDistance
            
            return
        }
        
        addTrainBtn.isEnabled = true
        let nowDateString = dateFormatter.string(from: Date(timeIntervalSinceNow: 0))
        dateTextField.text = nowDateString
    }
    
    
    @IBAction func addTrain(_ sender: UIBarButtonItem) {
        if let newSportName = sportNameTextField.text,
                let newDate = dateFormatter.date(from: dateTextField.text!),
                let newDuration = Int16(durationTextField.text!),
                let newDistance = Double((distanceTextField.text!)) {
            delegate?.didAdd(sportName: newSportName, date: newDate, duration: newDuration, distance: newDistance)
            
            navigationController?.popViewController(animated: true) // 页面出栈
        } else {
            fatalError()
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

