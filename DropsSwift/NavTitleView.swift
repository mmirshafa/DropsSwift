//
//  NavTitleView.swift
//  DropsSwift
//
//  Created by Mahan on 4/30/19.
//  Copyright © 2019 Nizek. All rights reserved.
//

import UIKit

class NavTitleView: _viewBase {

    override func initialize()
    {
        super.initialize();
        
        let titleLabel = UILabel();
        titleLabel.translatesAutoresizingMaskIntoConstraints = false;
        titleLabel.numberOfLines = 0;
        titleLabel.textAlignment = NSTextAlignment.center;
        titleLabel.adjustsFontSizeToFitWidth = true;
        titleLabel.textColor = UIColor.darkText;
        
    }

}
