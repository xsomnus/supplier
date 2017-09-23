//
//  MainLoginBtn.swift
//  HLScs
//
//  Created by @xwy_brh on 29/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit

class MainLoginBtn: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 18)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var titleRect = titleLabel?.frame
        var imageViewRect = imageView?.frame
        
        titleRect?.origin.x = (self.width - (titleRect?.size.width)!)/2
        titleLabel?.frame = titleRect!
        imageViewRect?.origin.x = self.width - (imageViewRect?.size.width)! - 10
        imageView?.frame = imageViewRect!
        
    }

}
















