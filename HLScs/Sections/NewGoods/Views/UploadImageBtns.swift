//
//  UploadImageBtns.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/13.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol  UploadImageBtnsDelegate {
    func uploadImageBtnsDidClicked(sender:UIButton, completeionHandler:ColsureBool_Void)
}


class UploadImageBtns: UIView {

    let btnCountInARow:Int = 4
    let btnSize = CGSize(width: (WID * 15)/4, height: (WID * 15)/4)
    
    var needAddClosure:ClosureVoid_Void?
    
    //标志是否有图片被上传
    var flagArray = [Bool]()
    
    //Mark: --- 标志该上传第几张图片, 从0开始
    var indexNow:Int = 0 {
        didSet {
            for btn in btnArr {
                if btn.tag <= indexNow {
                    btn.alpha = 1
                } else {
                    btn.alpha = 0
                }
            }
        }
    }
    
    //Mark: --- 按钮数组
    var btnArr = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBtns()
        initialBtnsAndFlagArr()
        
    }
    
    func initialBtnsAndFlagArr() {
        for btn in btnArr {
            if btn.tag == indexNow {
                btn.alpha = 1
            } else {
                btn.alpha = 0
            }
            flagArray.append(false)
        }
    }

    
    func createBtns() {
        var tmpX:CGFloat = 0
        for i in 0..<btnCountInARow {
            let btn = UIButton.init(type: .custom)
            btn.tag = i
            btn.setImage(UIImage.init(named: "hlscs_uploadImage_defalut"), for: .normal)
            btn.frame = CGRect(x: tmpX + WID, y: WID, width: btnSize.width, height: btnSize.height)
            tmpX = tmpX + (WID + btnSize.width)
            btn.addTarget(self, action: #selector(uploadImageAction(sender:)), for: .touchUpInside)
            btnArr.append(btn)
            self.addSubview(btn)
        }
    }
    
    var delegate:UploadImageBtnsDelegate?
    
    func uploadImageAction(sender:UIButton) {
        if let delegate = self.delegate {
            delegate.uploadImageBtnsDidClicked(sender: sender, completeionHandler: { isSuccess in
                if isSuccess {
                    print("上传成功!")
                } else {
                    print("上传失败!")
                }
            })
        }
        
        /*
        let isDone = arc4random_uniform(256) % 2 == 0 ? true : false
        //Mark: --- (1)上传成功之后, 改变indexNow的值 (2)标志该btn已经有图片了 
        if isDone {
            indexNow = flagArray[sender.tag] ? indexNow : indexNow + 1
            flagArray[sender.tag] = true
            sender.setImage(UIImage.init(named: "test"), for: .normal)
        } else {
            SVProgressHUD.setMaximumDismissTimeInterval(1)
            SVProgressHUD.showError(withStatus: "图片上传失败")
        }
        */
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
