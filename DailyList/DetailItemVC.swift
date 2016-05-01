//
//  DetailItemVC.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/1.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class DetailItemVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK: Private Method
    private func configVC() {
        
        self.view.backgroundColor = CustomColors.getBackgroundColor()
        
    }

    //MARK: Button Method
    @IBAction func backBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
