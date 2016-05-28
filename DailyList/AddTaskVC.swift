//
//  DetailItemVC.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/1.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit
import CoreData

class AddTaskVC: UIViewController {
    
    // @IBOutlet
    @IBOutlet weak var taskNameTextField: DesignableTextField!
    @IBOutlet weak var taskDateTextField: DesignableTextField!
    @IBOutlet weak var taskTimeTextField: DesignableTextField!
    @IBOutlet weak var memoTextView: DesignableTextView!
    @IBOutlet weak var taskNameImageView: SpringImageView!
    @IBOutlet weak var taskDateImageView: SpringImageView!
    @IBOutlet weak var taskTimeImageView: SpringImageView!
    @IBOutlet weak var taskAlertImageView: SpringImageView!
    @IBOutlet weak var taskAlertSwitch: UISwitch!
    @IBOutlet weak var taskAlertBgView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveButton: DesignableButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var displayDateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerBottomCT: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIToolbar!
    
    // property
    private var currentDate: DateInRegion = CurrentDate.sharedInstance.nowDate
    private var datePickerHeight: CGFloat?
    var pageData: Page?
    
    enum DatePickerType {
        case DatePickerTypeDate, DatePickerTypeTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configVC()
        // print(pageData)
    }
    
    //MARK: Private Method
    private func configVC() {
        
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        self.contentView.fullyRound(3.0, borderColor: nil, borderWidth: nil)
        
        self.taskNameTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskNameTextField.delegate = self

        self.taskDateTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskDateTextField.delegate = self
        
        self.taskTimeTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskTimeTextField.delegate = self
        
        self.memoTextView.borderColor = CustomColors.getTextFieldBgGreyColor()
        
        self.taskAlertBgView.fullyRound(5, borderColor: CustomColors.getTextFieldBgGreyColor(), borderWidth: 2)
        
        self.displayDateLabel.fullyRound(5, borderColor: nil, borderWidth: nil)
        self.displayDateLabel.text = "\(currentDate.year)/\(currentDate.month)/\(currentDate.day)"
        
        self.saveButton.backgroundColor = CustomColors.getMainColor()
        
        self.datePicker.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        datePickerHeight = -(self.datePicker.frame.size.height + self.toolBar.frame.size.height)
        self.datePickerBottomCT.constant = datePickerHeight!
        self.view.updateConstraintsIfNeeded()
    }
    
    private func callDatePicker(type: DatePickerType) {

        switch type {
        case .DatePickerTypeDate:
            datePicker.datePickerMode = .Date
            datePicker.minimumDate = CurrentDate.sharedInstance.nowDate.f
        default:
            <#code#>
        }
        
        self.datePickerBottomCT.constant = 0;
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func closeDatePicker() {
        
        self.datePickerBottomCT.constant = self.datePickerHeight!;
        UIView.animateWithDuration(0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: Touch event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        self.closeDatePicker()
    }

    //MARK: Button Method
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func alertSwitchChanged(sender: UISwitch) {
        if sender.on {
            self.taskAlertImageView.image = UIImage(named: "bell_icon")
            self.taskAlertImageView.animation = "zoomIn"
            self.taskAlertImageView.duration = 1.0
            self.taskAlertImageView.animate()
        } else {
            self.taskAlertImageView.image = UIImage(named: "bell_gray_icon")
        }
    }
    
    @IBAction func saveBtnPressed(sender: AnyObject) {
        
        var page: Page!
        var pageItem: PageItem!
        
        pageItem = NSEntityDescription.insertNewObjectForEntityForName("PageItem", inManagedObjectContext: ad.managedObjectContext) as! PageItem
        
        if let p = pageData {
            page = p
        } else {
            page = NSEntityDescription.insertNewObjectForEntityForName("Page", inManagedObjectContext: ad.managedObjectContext) as! Page
        }
        
        if let taskName = taskNameTextField.text {
            pageItem.title = taskName
        }

        page.year = String(currentDate.year)
        page.month = String(currentDate.month)
        page.day = String(currentDate.day)
        page.addPageItems(pageItem)
        ad.saveContext()
        
    }
}

extension AddTaskVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        let hasText: Bool = textField.text!.length > 0
        
        if textField == self.taskNameTextField {
            self.taskNameImageView.image = UIImage(named: "task_yellow_icon")
            if !hasText {
                self.taskNameImageView.animation = "zoomIn"
                self.taskNameImageView.duration = 1.0
                self.taskNameImageView.animate()
            }
        }
        else if textField == self.taskDateTextField {
            textField.resignFirstResponder()
            self.taskDateImageView.image = UIImage(named: "calendar_yellow_icon")
            if !hasText {
                self.taskDateImageView.animation = "zoomIn"
                self.taskNameImageView.duration = 1.0
                self.taskDateImageView.animate()
                self.callDatePicker(.DatePickerTypeDate)
            }
        }
        else if textField == self.taskTimeTextField {
            textField.resignFirstResponder()
            self.taskTimeImageView.image = UIImage(named: "taskTime_yellow_icon")
            if !hasText {
                self.taskTimeImageView.animation = "zoomIn"
                self.taskNameImageView.duration = 1.0
                self.taskTimeImageView.animate()
                self.callDatePicker(.DatePickerTypeTime)
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        let hasText: Bool = textField.text!.length > 0
        
        if !hasText {
            if textField == self.taskNameTextField {
                self.taskNameImageView.image = UIImage(named: "task_gray_icon")
            }
            else if textField == self.taskDateTextField {
                self.taskDateImageView.image = UIImage(named: "calendar_gray_icon")
            }
            else if textField == self.taskTimeTextField {
                self.taskTimeImageView.image = UIImage(named: "taskTime_gray_icon")
            }
        }
    }
}
