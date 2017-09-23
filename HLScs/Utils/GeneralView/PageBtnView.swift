//
//  PageBtnView.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/11.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

protocol PageBtnViewDelegate {
    
    func pageBtnViewDidSelect(index:Int)
}


class PageBtnView: UIView {
    
    var delegate:PageBtnViewDelegate?
    
    var pageCount:Int?
    var oldSelectedIndex:Int?
    var selectedIndex:Int = 1 {
        didSet {
            if let oldSelectedIndex = self.oldSelectedIndex {
                btnArr[oldSelectedIndex].setTitleColor(UIColor.init(gray: 200), for: .normal)
                btnArr[oldSelectedIndex].titleLabel?.font = font(15)
                btnArr[selectedIndex].setTitleColor(UIColor.appMainColor(), for: .normal)
                btnArr[selectedIndex].titleLabel?.font = font(18)
            }
        }
    }
    var btnArr = [UIButton]()
    
    init(frame: CGRect, pageCount:Int) {
        super.init(frame: frame)
        self.pageCount = pageCount
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func btnClick(sender:UIButton) {
        oldSelectedIndex = self.selectedIndex
        
        switch sender.tag {
        case 0:
            if selectedIndex == 1 {
                selectedIndex = pageCount!
            } else {
                selectedIndex = selectedIndex - 1
            }
        case self.pageCount! + 1:
            if selectedIndex == pageCount {
                selectedIndex = 1
            } else {
                selectedIndex = selectedIndex + 1
            }
        case selectedIndex:
            return
        default:
            selectedIndex = sender.tag
        }
        
        if let delegate = self.delegate {
            delegate.pageBtnViewDidSelect(index: self.selectedIndex)
        }
    }
    
    func setupUI() {
        guard let pageCount = pageCount else {
            return
        }
        
        if pageCount == 0 {
            return
        }
        
        let btnWidth = kScreenW/12
        if pageCount == 1 {
            
            let btn = UIButton.init(type: .system)
            btn.frame = CGRect(x: kScreenW/2 - btnWidth/2, y: 0, width: btnWidth, height: 30)
            btn.setTitle("1", for: .normal)
            btn.setTitleColor(UIColor.appMainColor(), for: .normal)
            btn.backgroundColor = UIColor.randomColor()
            self.addSubview(btn)
            return
        }
        
        var tmpX:CGFloat = 0
        if pageCount % 2 == 0 {
            tmpX = kScreenW/2 - btnWidth * CGFloat((pageCount + 2)/2)
        } else {
            tmpX = kScreenW/2 - btnWidth * CGFloat((pageCount + 2)/2)
            tmpX = tmpX - btnWidth/2
        }
        //Mark: --- 有两个左右按钮
        for i in 0..<pageCount+2 {
            let btn = UIButton.init(type: .custom)
            btn.frame = CGRect(x: tmpX, y: 0, width: btnWidth, height: 30)
            tmpX = tmpX + btnWidth
            switch i {
            case 0:
                btn.setImage(UIImage.init(named: "hlscs_leftDirection_arraow"), for: .normal)
            case pageCount + 1:
                btn.setImage(UIImage.init(named: "hlscs_rightDirection_arraow"), for: .normal)
            default:
                btn.setTitle("\(i)", for: .normal)
            }
            btn.tag = i
            if i == self.selectedIndex {
                btn.setTitleColor(UIColor.appMainColor(), for: .normal)
                btn.titleLabel?.font = font(18)
            } else {
                btn.setTitleColor(UIColor.init(gray: 200), for: .normal)
                btn.titleLabel?.font = font(15)
            }
            btn.addTarget(self, action: #selector(btnClick(sender:)), for: .touchUpInside)
            
            self.addSubview(btn)
            btnArr.append(btn)
        }
        
    }
    
    
}
