//
//  GridTVAsideView.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit




class GridTVAsideView: UIView {

  
    //Mark: --- 行数, 用来创建scrollView使用
    var rowCount:Int? {
        didSet {
            self.addSubview(containerScrollView)
            self.addSubview(titleHeaderView)
            createItemsView()
        }
    }
    
    //Mark: --- 列数, 用来创建每个子视图的时候使用
    var colCount:Int?
    
    //Mark: --- 标题数据源
    var titleArr = [String]()
    
    //Mark: --- 标题宽度占比
    var titleWidthWeight = [Int]()
    
    //Mark: --- 数据源
    var dataSource = [GridTVGoodsModel]()
    
    //Mark: --- 每个item的宽度 , 大于2位父视图的一半, 等于1则为父视图的宽度
    var itemWidth:CGFloat?
    
    /* 可选UI配置项 */
    //Mark: --- headerView的高度
    var titleViewHeight:CGFloat?
    
    //Mark: --- headerView的背景色
    var titleViewBgColor:UIColor?
    
    //Mark: --- headerView的字体颜色
    var titleTextColor:UIColor?
    
    //Mark: --- Cell height / 每个cell的高度
    var cellHeight:CGFloat?
    
    //Mark: --- label color
    var labelColor:UIColor?
    
    //Mark: --- label size 
    var labelFont:UIFont?
    
    
    //Mark: --- 容器scrolleView
    lazy var containerScrollView:UIScrollView = {[weak self] in
        let rect = CGRect(x: 0, y: 20, width: (self?.width)!, height: (self?.height)!)
        let scrollView:UIScrollView = UIScrollView.init(frame: rect)
        let count = CGFloat((self?.titleArr.count)!)
    
        if let rowCount = self?.rowCount {
            let contentHeight = CGFloat(rowCount) * ((self?.height)!/15)
            let contentSize:CGSize = CGSize(width: count * (self?.itemWidth)!, height: contentHeight)
            scrollView.contentSize = contentSize
        }
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = false
        
        return scrollView
    }()
    
    
    //Mark: --- 标题视图
    lazy var titleHeaderView:UIView = {[weak self] in
        let view = UIView.init()
        let count = CGFloat((self?.titleArr.count)!)
        view.frame = CGRect(x: 0, y: 0, width: count * (self?.itemWidth)!, height: 20)
        guard let titleCounts = self?.titleArr.count else {
            fatalError("标题数据不能为空!")
        }
        var maxX:CGFloat = 0
        for i in 0..<titleCounts {
            
            let frame = CGRect(x: maxX, y: 0, width: (self?.itemWidth)!, height: view.height)
            maxX = maxX + (self?.itemWidth)!
            
            let btn = UIButton.init(type: .custom)
            btn.setTitle(self?.titleArr[i], for: .normal)
            let titleTextColor = self?.titleTextColor == nil ? UIColor.white : self?.titleTextColor!
            btn.setTitleColor(titleTextColor, for: .normal)
            btn.frame = frame
            btn.tag = i
            btn.titleLabel?.font = font(12)
            view.addSubview(btn)
        }
        
        let bgColor = self?.titleViewBgColor == nil ? UIColor.colorFromHex(0x5DECB8) : UIColor.gray
        view.backgroundColor = bgColor
        return view
    }()
    
    var allItemsArray = [[UILabel]]()
    
    //Mark: --- 子视图
    func createItemsView() {
        var tmpY:CGFloat = 0
        let rowHeight = (self.height-20)/15
        for _ in 0..<rowCount! {
            let rowView = UIView.init()
            rowView.frame = CGRect(x: 0, y: tmpY, width: itemWidth!, height: rowHeight)
            var tmpX:CGFloat = 0
            var tmpColLabelArray = [UILabel]()
            for _ in 0..<colCount! {
                let label = UILabel.init()
                label.frame = CGRect(x: tmpX, y: 0, width: itemWidth!, height: rowHeight)
                tmpX = tmpX + itemWidth!
                tmpColLabelArray.append(label)
                
                label.textAlignment = .center
                if let font = self.labelFont {
                    label.font = font
                }
                if let color = self.labelColor {
                    label.textColor = color
                }
                rowView.addSubview(label)
            }
            tmpY = tmpY + rowHeight
            allItemsArray.append(tmpColLabelArray)
            
            _ = UIView().then {
                $0.backgroundColor = UIColor.colorFromHex(0xD3D3D3)
                rowView.addSubview($0)
                $0.snp.makeConstraints({ (make) in
                    make.height.equalTo(1)
                    make.width.bottom.left.equalToSuperview()
                })
            }
            
            self.containerScrollView.addSubview(rowView)
        }
        
    }
    
    //Mark: --- 根据(行, 列)对label进行赋值
    func setValueWith(position:(Int, Int), text:String) {
        if position.0 >= rowCount! {
            fatalError("超出了范围")
        }
        if position.1 >= colCount! {
            fatalError("超出了范围")
        }
        
        let label = allItemsArray[position.0][position.1]
        label.text = text
    }
    
     init(frame: CGRect, titleArr:[String]) {
        super.init(frame: frame)
        self.titleArr = titleArr
        initTitleWidthWeight()
        colCount = titleArr.count
        //Mark: --- 最多显示2个, 如果只有一个的话就显示视图的全部宽度
        itemWidth = titleArr.count == 1 ? frame.size.width : (frame.size.width)/2
    }
    
    func initTitleWidthWeight() {
        if titleWidthWeight.count != titleArr.count {
            titleWidthWeight.removeAll()
            for _ in 0..<titleArr.count {
                titleWidthWeight.append(1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
