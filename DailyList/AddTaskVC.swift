//
//  DetailItemVC.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/1.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class AddTaskVC: UIViewController, UITextFieldDelegate {
    
    // @IBOutlet
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDateTextField: UITextField!
    @IBOutlet weak var taskTimeTextField: UITextField!
    @IBOutlet weak var taskAlertSwitch: UISwitch!
    @IBOutlet weak var taskAlertBgView: UIView!
    @IBOutlet weak var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configVC()
    }
    
    //MARK: Private Method
    private func configVC() {
        
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        
        self.taskNameTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()

        self.taskDateTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.taskTimeTextField.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.taskAlertBgView.fullyRound(3, borderColor: CustomColors.getTextFieldBgGreyColor(), borderWidth: 2)
        
    }

    //MARK: Button Method
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
