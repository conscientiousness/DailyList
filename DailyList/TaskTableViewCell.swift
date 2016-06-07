//
//  TaskTableViewCell.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/1.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var taskBgView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var taskIconImageView: UIImageView!
//  @IBOutlet weak var imgHeightCT: NSLayoutConstraint!
    
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        if selected {
//            self.taskBgView.backgroundColor = UIColor.lightGrayColor()
//        }
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = CustomColors.getTextFieldBgGreyColor()
    }

    func configCell(indexPath: NSIndexPath, pageItem: PageItem) {
        
        self.updateConstraintsIfNeeded()
        
        if let title = pageItem.title {
            titleLabel.text = title
        }
        
        if let detail = pageItem.detail {
            detailLabel.text = detail
        }
        
        if let status = pageItem.status {
            switch Int(status) {
            case 1:
                self.taskIconImageView.image = UIImage(named: "task_done_icon")
            case 2:
                self.taskIconImageView.image = UIImage(named: "task_expired_icon")
            default:
                self.taskIconImageView.image = UIImage(named: "task_todo_icon")
            }
        }
    }
}
