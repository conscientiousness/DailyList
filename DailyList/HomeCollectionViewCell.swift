//
//  HomeCollectionViewCell.swift
//  DailyMind
//
//  Created by Jesselin on 2016/3/16.
//  Copyright © 2016年 iCircle. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.fullyRound(10, borderColor: CustomColors.getMainColor(), borderWidth: 0)
        
        //self.collectionView!.registerNib(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
    }

}

//extension HomeCollectionViewCell: UITableViewDelegate,UITableViewDataSource {
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return 10;
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        return UITableViewCell;
//    }
//}
