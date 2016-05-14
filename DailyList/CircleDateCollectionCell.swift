//
//  CircleDateCollectionCell.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/13.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class CircleDateCollectionCell: UICollectionViewCell {
 
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(indexPath: NSIndexPath, currentDate: NSDate) {
        
        let dayInt: Int = indexPath.row + 1
        self.fullyRound(self.frame.size.width, borderColor: CustomColors.getMainColor(), borderWidth: 0)
        self.weekLabel.text =  DateCenter.getWeekDayString(DateCenter.getCurrentDate(currentDate, currentCellIdx: indexPath.row), shortString: true)
        self.dayLabel.text = String(dayInt)

            
        if self.selected {
            self.backgroundColor = CustomColors.getLightGreenColor()
        }
        else {
            self.backgroundColor = UIColor.clearColor()
        }
        
        if dayInt == currentDate.day {
            self.backgroundColor = CustomColors.getMainColor()
        }
    }
}
