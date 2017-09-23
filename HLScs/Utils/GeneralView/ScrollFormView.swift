//
//  ScrollFormView.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then
import SVProgressHUD

protocol ScrollFormViewDelegate {
    func ScrollFormViewDidCommit(titles:[String]?, tfArray:[UITextField]?)
}

class ScrollFormView: UIView {

    
    var rowCount:Int?
    var titleDataSource:[String]?
    var cellHeight:CGFloat?  //Mark: --- 默认高度为44
    var inputTFArray = [UITextField]()
    var valueDataSource = [String]()
    
    var delegate:ScrollFormViewDelegate?
    var uploadImageBtns:UploadImageBtns?
    var textfieldDelegate:UITextFieldDelegate?
    
    //Mark: --- 容器scrolleView
    lazy var containerScrollView:UIScrollView = {[weak self] in
        let scrollView:UIScrollView = UIScrollView.init(frame: (self?.bounds)!)
        let count = CGFloat((self?.titleDataSource?.count)!)
        
        if let rowCount = self?.rowCount {
            var contentHeight:CGFloat = 0
            if let cellHeight = self?.cellHeight{
                contentHeight = CGFloat(rowCount) * (cellHeight+0.5)
            } else {
                contentHeight = CGFloat(rowCount) * (44+0.5)
            }
            contentHeight  = contentHeight + 30 + WID * 2 + (WID * 15)/4 + 50 + 10
            let contentSize:CGSize = CGSize(width: (self?.width)!, height: contentHeight)
            scrollView.contentSize = contentSize
        }
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
        }()

    
    lazy var commitBtn = {() -> MainLoginBtn in
        let btn = MainLoginBtn(type: .custom)
        btn.setTitle("提交", for: .normal)
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        btn.addTarget(self, action: #selector(commitAction), for: .touchUpInside)
        return btn
    }()
    
    func commitAction() {
        if let delegate = self.delegate {
            delegate.ScrollFormViewDidCommit(titles: titleDataSource, tfArray: inputTFArray)
        }
    }

    
    
    init(frame: CGRect, titleDataSource:[String], tfDelegate:UITextFieldDelegate, completionHandler:(([UITextField]?)->Void)) {
        super.init(frame: frame)
        self.titleDataSource = titleDataSource
        self.rowCount = titleDataSource.count
        self.addSubview(containerScrollView)
        self.textfieldDelegate = tfDelegate
        setupTFs()
        completionHandler(inputTFArray)
    }
    
    func setupTFs() {
        //Mark: --- 数字键盘索引
        let numIndexs = [1, 4, 5, 7]

        if let rowCount = self.rowCount {
            if rowCount == 0 { return }
            var tmpY:CGFloat = 0
            for i in 0..<rowCount {
                let title = titleDataSource![i]
                let textfield = UITextField.init()
                
                textfield.leftViewMode = .always
                let asideBtn = TitleLeftBtn.init(type: .custom)
                asideBtn.setTitle(title, for: .normal)
                asideBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                asideBtn.setTitleColor(UIColor.colorFromHex(0x030303), for: .normal)
               
                if numIndexs.contains(i) {
                    textfield.keyboardType = .decimalPad
                    if i == 7 {
                        textfield.keyboardType = .numberPad
                    }
                }
                
                textfield.leftView = asideBtn
                
                if let textfieldDelegate = self.textfieldDelegate {
                    textfield.delegate = textfieldDelegate
                }
                
                textfield.placeholder = "请输入\(title)"
                textfield.textColor = UIColor.init(gray: 232)
                textfield.clearButtonMode = UITextFieldViewMode.always
                textfield.font = UIFont.systemFont(ofSize: 15)
                
                let sepView = UIView.init()
                sepView.backgroundColor = UIColor.colorFromHex(0xe2e2e2)
                
                if let cellHeight = self.cellHeight {
                    textfield.frame = CGRect(x: 0, y: tmpY, width: self.width, height: cellHeight)
                    textfield.leftView?.frame = CGRect(x: 0, y: 0, width: self.width/4, height: cellHeight)
                    tmpY = tmpY + cellHeight
                    sepView.frame = CGRect(x: WID, y: tmpY, width: self.width - WID, height: 0.5)
                    tmpY = tmpY + 1
                } else {
                    textfield.frame = CGRect(x: 0, y: tmpY, width: self.width, height: 44)
                    textfield.leftView?.frame = CGRect(x: 0, y: 0, width: self.width/4, height: 44)
                    tmpY = tmpY + 44
                    sepView.frame = CGRect(x: WID, y: tmpY, width: self.width - WID, height: 0.5)
                    tmpY = tmpY + 1
                }
                
                inputTFArray.append(textfield)
                containerScrollView.addSubview(textfield)
                containerScrollView.addSubview(sepView)
            }
            
            _ = UILabel.init().then{
                self.addSubview($0)
                $0.text = "上传海报图"
                $0.font = font(15)
                $0.frame = CGRect(x: WID, y: tmpY + 5, width: self.width, height: 20)
                tmpY = tmpY + 30
                containerScrollView.addSubview($0)
                
            }
            
            self.uploadImageBtns = UploadImageBtns.init(frame: CGRect(x: 0, y: tmpY, width: self.width, height: WID * 2 + (WID * 15)/4)).then {
                containerScrollView.addSubview($0)
            }
            tmpY = tmpY + WID * 2 + (WID * 15)/4
            
            commitBtn.frame = CGRect(x: 30, y: tmpY, width: kScreenW - 60, height: 50)
            containerScrollView.addSubview(commitBtn)
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



