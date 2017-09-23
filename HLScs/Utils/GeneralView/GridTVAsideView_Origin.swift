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
    var rowCount:Int?
    
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
    
    
    //Mark: --- 容器scrolleView
    lazy var containerScrollView:UIScrollView = {[weak self] in
        let scrollView:UIScrollView = UIScrollView.init(frame: (self?.bounds)!)
        let count = CGFloat((self?.titleArr.count)!)
        let contentSize:CGSize = CGSize(width: count * (self?.itemWidth)!, height: (self?.height)!)
        scrollView.contentSize = contentSize
        scrollView.bounces = false
        scrollView.showsHorizontalScrollIndicator = false
       
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
    
     init(frame: CGRect, titleArr:[String]) {
        super.init(frame: frame)
        self.titleArr = titleArr
        initTitleWidthWeight()
        //Mark: --- 最多显示2个, 如果只有一个的话就显示视图的全部宽度
        itemWidth = titleArr.count == 1 ? frame.size.width : (frame.size.width)/2
        
        self.addSubview(containerScrollView)
        containerScrollView.addSubview(titleHeaderView)
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
