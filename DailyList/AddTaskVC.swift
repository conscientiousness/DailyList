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
    @IBOutlet weak var displayTimeLabel: UILabel!
    @IBOutlet weak var containerTopCT: NSLayoutConstraint!
    @IBOutlet weak var buttonBottomCT: NSLayoutConstraint!
    var datePicker: UIDatePicker!
    var timePicker: UIDatePicker!

    // property
    private var currentDate: DateInRegion = CurrentDate.sharedInstance.nowDate
    private var datePickerHeight: CGFloat?
    private var pickerDate: DateInRegion?
    private var pickerTime: DateInRegion?
    private var pickType: DatePickerType = .DatePickerTypeDate
    var pageData: Page?
    
    enum DatePickerType {
        case DatePickerTypeDate, DatePickerTypeTime
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configVC()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddTaskVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AddTaskVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //MARK: Private Method
    private func configVC() {
        
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        self.contentView.fullyRound(3.0, borderColor: nil, borderWidth: nil)
        
        self.taskNameTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskNameTextField.delegate = self

        self.taskDateTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskDateTextField.delegate = self
        datePicker = UIDatePicker(frame: CGRectZero)
        datePicker.datePickerMode = .Date
        datePicker.minimumDate = NSDate(year: currentDate.year, month: currentDate.month, day: 1)
        datePicker.maximumDate = NSDate(year: currentDate.year, month: currentDate.month, day: currentDate.monthDays)
        datePicker.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        datePicker.addTarget(self, action: #selector(self.datePickerValChg(_:)), forControlEvents: .ValueChanged)
        self.taskDateTextField.inputView = datePicker
        self.taskDateTextField.inputAccessoryView?.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        //self.taskDateTextField.inputAccessoryView = toolBar
        
        
        self.taskTimeTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskTimeTextField.delegate = self
        timePicker = UIDatePicker(frame: CGRectZero)
        timePicker.datePickerMode = .Time
        timePicker.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        timePicker.addTarget(self, action: #selector(self.timePickerValChg(_:)), forControlEvents: .ValueChanged)
        self.taskTimeTextField.inputView = timePicker
        //self.taskTimeTextField.inputAccessoryView = toolBar
        
        self.memoTextView.borderColor = CustomColors.getTextFieldBgGreyColor()
        
        self.taskAlertBgView.fullyRound(5, borderColor: CustomColors.getTextFieldBgGreyColor(), borderWidth: 2)
        
        currentDate = DateInRegion(year: currentDate.year, month: currentDate.month, day: currentDate.day, hour: NSDate().hour, minute: NSDate().minute)
        
        self.displayDateLabel.fullyRound(5, borderColor: nil, borderWidth: nil)
        self.displayDateLabel.text = "\(currentDate.year)/\(currentDate.month)/\(currentDate.day)"
        
        self.displayTimeLabel.fullyRound(5, borderColor: nil, borderWidth: nil)
        self.displayTimeLabel.text = "\(DateCenter.timeWithLeadingZero(currentDate.hour)):\(DateCenter.timeWithLeadingZero(currentDate.minute))"
        
        self.saveButton.backgroundColor = CustomColors.getMainColor()
    }
    
    //MARK: Touch event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    func focusTextField() {
        self.taskNameTextField.becomeFirstResponder()
    }
    
    //MARK: Keyboard Event
    func keyboardWillShow(notification: NSNotification) {
        
        if memoTextView.isFirstResponder() {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                self.containerTopCT.constant -= keyboardSize.height
                self.buttonBottomCT.constant += keyboardSize.height;
                UIView.animateWithDuration(0.3, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        if memoTextView.isFirstResponder() {
            self.containerTopCT.constant = 0
            self.buttonBottomCT.constant = 20;
            UIView.animateWithDuration(0.3, animations: { () -> Void in self.view.layoutIfNeeded() })
        }
    }

    //MARK: Button Method
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func datePickerValChg(sender: UIDatePicker) {
        pickerDate = DateInRegion(year: datePicker.date.year, month: datePicker.date.month, day: datePicker.date.day)
        taskDateTextField.text = "\(pickerDate!.year)/\(pickerDate!.month)/\(pickerDate!.day)"
    }
    
    func timePickerValChg(sender: UIDatePicker) {
        pickerTime = DateInRegion(year: timePicker.date.year, month: timePicker.date.month, day: timePicker.date.day, hour: timePicker.date.hour, minute: timePicker.date.minute)
        taskTimeTextField.text = "\(DateCenter.timeWithLeadingZero(pickerTime!.hour)):\(DateCenter.timeWithLeadingZero(pickerTime!.minute))"
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
        
        var page: Page
        var pageItem: PageItem
        
        pageItem = NSEntityDescription.insertNewObjectForEntityForName("PageItem", inManagedObjectContext: ad.managedObjectContext) as! PageItem
        
        if let p = pageData {
            page = p
        } else {
            page = NSEntityDescription.insertNewObjectForEntityForName("Page", inManagedObjectContext: ad.managedObjectContext) as! Page
        }
        
        if let taskName = taskNameTextField.text where taskNameTextField.text?.length > 0 {
            pageItem.title = taskName
            
            if let pickerTime = self.pickerTime {
                pageItem.hour = pickerTime.hour
                pageItem.min = pickerTime.minute
            } else {
                pageItem.hour = currentDate.hour
                pageItem.min = currentDate.minute
            }
            
            pageItem.detail = memoTextView.text
            pageItem.needAlert = taskAlertSwitch.on
            pageItem.status = 0
            
            page.year = String(currentDate.year)
            page.month = String(currentDate.month)
            if let pickerDate = self.pickerDate {
                page.day = String(pickerDate.day)
            } else {
               page.day = String(currentDate.day)
            }
            
            page.addPageItems(pageItem)
            ad.saveContext()
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.showAlert({ 
                self.focusTextField()
            })
        }
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
            self.taskDateImageView.image = UIImage(named: "calendar_yellow_icon")
            if !hasText {
                self.taskDateImageView.animation = "zoomIn"
                self.taskNameImageView.duration = 1.0
                self.taskDateImageView.animate()
            }
        }
        else if textField == self.taskTimeTextField {
            self.taskTimeImageView.image = UIImage(named: "taskTime_yellow_icon")
            if !hasText {
                self.taskTimeImageView.animation = "zoomIn"
                self.taskNameImageView.duration = 1.0
                self.taskTimeImageView.animate()
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
