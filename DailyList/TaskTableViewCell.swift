//
//  TaskTableViewCell.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/1.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var taskIconImageView: UIImageView!
    @IBOutlet weak var imgHeightCT: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = CustomColors.getTextFieldBgGreyColor()
    }

    func configCell(indexPath: NSIndexPath, pageItem: PageItem) {
        
        if taskIconImageView.hidden {
            imgHeightCT.constant = 0;
        } else {
            imgHeightCT.constant = 98;
        }
        
        self.updateConstraintsIfNeeded()
        
        titleLabel.text = pageItem.title
        
        if indexPath.row % 5 == 0 {
            
            self.taskIconImageView.image = UIImage(named: "task_done_icon")
            
        } else if indexPath.row % 5 == 1 {
            
            self.taskIconImageView.image = UIImage(named: "task_todo_icon")
            
        } else {
            
            self.taskIconImageView.image = UIImage(named: "task_expired_icon")
        }
    }
}
