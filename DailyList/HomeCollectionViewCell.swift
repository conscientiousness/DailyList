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
    
    var itemsAry = [PageItem]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = CustomColors.getBackgroundColor()
        self.taskTableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.taskTableView.separatorStyle = .None
        self.taskTableView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskTableView.rowHeight = UITableViewAutomaticDimension
        
        self.cellContentView.fullyRound(8, borderColor: nil, borderWidth: nil)
        self.cellContentView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        
        self.dataListView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
    }
    
    override func prepareForReuse() {
        itemsAry = [PageItem]()
        self.taskTableView.reloadData()
    }
    
    func configCell(indexPath: NSIndexPath, dataDict: Dictionary<String, Page>) {
        
        
        let imgName: String = "empty_photo\((indexPath.row % 6) + 1)"
        self.emptyImageView.image = UIImage(named: imgName)
        let cellDate = DateCenter.getCurrentDateWithCellIndex(indexPath.row)
        self.emptyLabel.text = "You have nothing on \(cellDate.month)/\(cellDate.day)"

        if let value = dataDict[String(cellDate.day)] {
            if let items = value.pageItems {
                self.itemsAry = items.allObjects as! [PageItem]
            }
            self.taskTableView.reloadData()
        }
        
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.itemsAry.count > 0 {
            self.dataListView.hidden = false
            self.emptyView.hidden = true
            return self.itemsAry.count
        }
        
        self.dataListView.hidden = true
        self.emptyView.hidden = false
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
        
        cell.configCell(indexPath, pageItem: self.itemsAry[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80;
    }
}
