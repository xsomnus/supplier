//
//  TitleLeftBtn.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class TitleLeftBtn: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.textAlignment = .left
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var titleRect = titleLabel?.frame
        titleRect?.origin.x = WID
        titleLabel?.frame = titleRect!
    }

}
