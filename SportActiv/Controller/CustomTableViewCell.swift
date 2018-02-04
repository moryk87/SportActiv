//
//  CustomTableViewCell.swift
//  SportActiv
//
//  Created by Jan Moravek on 30/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    let nameLabelCell = UILabel()
    let locationLabelCell = UILabel()
    let lengthLabelCell = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
     
        nameLabelCell.translatesAutoresizingMaskIntoConstraints = false
        locationLabelCell.translatesAutoresizingMaskIntoConstraints = false
        lengthLabelCell.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(nameLabelCell)
        contentView.addSubview(locationLabelCell)
        contentView.addSubview(lengthLabelCell)
        
        let viewsDict = [
            "name" : nameLabelCell,
            "location" : locationLabelCell,
            "length" : lengthLabelCell,
            ] as [String : Any]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[name]|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-[location]-[length]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[length]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-[name]-[location]-|", options: [], metrics: nil, views: viewsDict))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
