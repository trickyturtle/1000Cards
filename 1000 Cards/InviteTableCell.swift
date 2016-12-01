//
//  InviteTableCell.swift
//  1000 Cards
//
//  Created by Isaac Garza on 11/21/16.
//  Copyright © 2016 Isaac Garza. All rights reserved.
//

import Foundation

class InviteTableCell: UITableViewCell {
    
    // MARK: PROPERTIES
    var textField : UITextField = UITextField()

    //This will NOT get called unless you call "registerClass, forCellReuseIdentifier" on your tableview
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        //First Call Super
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Initialize Text Field
        self.textField = UITextField(frame: CGRect(x: 8, y: 6, width: 359, height: 30));
        
        //Add TextField to SubView
        self.addSubview(self.textField)
    }
    
    //This function is apparently required; gets called by default if you don't call "registerClass, forCellReuseIdentifier" on your tableview
    required init(coder aDecoder: NSCoder) {
        //Just Call Super
        super.init(coder: aDecoder)!
    }
}
