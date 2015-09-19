//
//  FilterViewCell.swift
//  huez
//
//  Created by Frank Reine on 18.05.15.
//  Copyright (c) 2015 Frank Reine. All rights reserved.
//

import UIKit

class FilterViewCell: UICollectionViewCell {
    
    @IBOutlet var filterImage: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let bgView = UIView(frame: bounds)
        bgView.backgroundColor = UIColor.whiteColor()
        selectedBackgroundView = bgView
    }
}
