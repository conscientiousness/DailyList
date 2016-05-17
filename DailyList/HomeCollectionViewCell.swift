//
//  HomeCollectionViewCell.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/16.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var emptyImageView: UIImageView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.taskTableView.registerNib(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        self.taskTableView.separatorStyle = .None
        self.taskTableView.backgroundColor = CustomColors.getTextFieldBgGreyColor()
        self.fullyRound(8, borderColor: nil, borderWidth: nil)
    }
    
    func configCell(indexPath: NSIndexPath, currentDate: NSDate) {
        
        let imgName: String = "empty_photo\((indexPath.row % 6) + 1)"
        self.emptyImageView.image = UIImage(named: imgName)
        
        let date = DateCenter.getCurrentDateWithCellIndex(indexPath.row, date: currentDate)
        self.emptyLabel.text = "You have nothing on \(date.month)/\(date.day)"
    }
}

extension HomeCollectionViewCell: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! TaskTableViewCell
        cell.configCell(indexPath)
        
        return cell
    }
}

extension HomeCollectionViewCell: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180;
    }
}
