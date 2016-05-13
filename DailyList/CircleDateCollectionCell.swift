//
//  CircleDateCollectionCell.swift
//  DailyList
//
//  Created by Jesselin on 2016/5/13.
//  Copyright © 2016年 JesseLin. All rights reserved.
//

import UIKit

class CircleDateCollectionCell: UICollectionViewCell {
 
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell() {
        self.fullyRound(self.frame.size.width, borderColor: CustomColors.getMainColor(), borderWidth: 0)
    }
    
}
