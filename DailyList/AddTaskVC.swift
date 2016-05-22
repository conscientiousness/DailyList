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
    
    // property
    var currentDate: NSDate?
    var itemToEdit: Page?
    var pages = [Page]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configVC()
        
        let request = NSFetchRequest(entityName: "Page")
        do {
            self.pages = try ad.managedObjectContext.executeFetchRequest(request) as! [Page]
        } catch {}
        
        for page: Page in pages {

            if let pageItems = page.pageItems {
                for item: PageItem in pageItems.allObjects as! [PageItem] {
                    print("task name = \(item.title!)")
                }
            }
            
        }
    }
    
    //MARK: Private Method
    private func configVC() {
        
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        
        self.taskNameTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskNameTextField.delegate = self

        self.taskDateTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskDateTextField.delegate = self
        
        self.taskTimeTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskTimeTextField.delegate = self
        
        self.taskAlertBgView.fullyRound(5, borderColor: CustomColors.getTextFieldBgGreyColor(), borderWidth: 2)
        
        self.displayDateLabel.fullyRound(5, borderColor: nil, borderWidth: nil)
        if let currentDate = currentDate {
            self.displayDateLabel.text = "\(currentDate.year)/\(currentDate.month)/\(currentDate.day)"
        }
        
        self.saveButton.backgroundColor = CustomColors.getMainColor()
    }
    
    //MARK: Touch event
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
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
        
        if itemToEdit == nil {
            page = NSEntityDescription.insertNewObjectForEntityForName("Page", inManagedObjectContext: ad.managedObjectContext) as! Page
            pageItem = NSEntityDescription.insertNewObjectForEntityForName("PageItem", inManagedObjectContext: ad.managedObjectContext) as! PageItem
        } else {
            page = itemToEdit
        }
        
        if let taskName = taskNameTextField.text {
            pageItem.title = taskName
        }
        
        if let currentDate = currentDate {
            page.pageDate = "\(currentDate.year)\(currentDate.month)\(currentDate.day)"
        }
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
}
