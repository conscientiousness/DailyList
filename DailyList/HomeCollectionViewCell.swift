//
//  HomeCollectionViewCell.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/16.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit
import CoreData

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var cellContentView: SpringView!
    @IBOutlet weak var dataListView: UIView!
    @IBOutlet weak var emptyView: UIView!
    var itemsArray = [PageItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = CustomColors.getBackgroundColor()
        self.taskTableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.taskTableView.separatorStyle = .None
        self.taskTableView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.cellContentView.fullyRound(8, borderColor: nil, borderWidth: nil)
        self.cellContentView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.dataListView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
    }
    
    func configCell(indexPath: NSIndexPath) {
        
        print("idx = \(indexPath.row)")
        let imgName: String = "empty_photo\((indexPath.row % 6) + 1)"
        self.emptyImageView.image = UIImage(named: imgName)
        let cellDate = DateCenter.getCurrentDateWithCellIndex(indexPath.row, date: CurrentDate.sharedInstance.nowDate)
        self.emptyLabel.text = "You have nothing on \(cellDate.month)/\(cellDate.day)"
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.itemsArray.count > 0 {
            self.dataListView.hidden = false
            self.emptyView.hidden = true
            return self.itemsArray.count
        }
        
        self.dataListView.hidden = true
        self.emptyView.hidden = false
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
        
        cell.configCell(indexPath, pageItem: self.itemsArray[indexPath.row])
        
        return cell
    }
}

extension HomeCollectionViewCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180;
    }
}