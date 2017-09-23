//
//  BiddingVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit

class BiddingVC: BaseVC {

    var dataSource:[RepGoodsModel]? {
        didSet {
            self.childGridTVVC.dataSource = dataSource
        }
    }
    
    lazy var childGridTVVC:GridTVVC = {[weak self] in
        let rect = CGRect(x: 0, y: 50, width: WID * 15, height: gridVCHeight + kStatusBarH + kNavigationBarH)
        let vc = GridTVVC.init(style: .grouped, titleArr: ["序号", "名称", "编码", "单位", "合计"], frame:rect)
        vc.titleWidthWeight = [1, 2, 2, 1, 2]
        vc.dataIndexArray = [0, 1, 2, 3, 4]
        vc.delegate = self
        return vc
        }()
    lazy var childGridAsideView:GridTVAsideView = {[weak self] in
        let rect = CGRect(x: WID * 15, y: 50, width: WID * 5, height: gridVCHeight)
        let view = GridTVAsideView.init(frame: rect, titleArr: ["竞价单价"])
        view.labelColor = UIColor.appMainColor()
        view.labelFont  = font(15)
        view.rowCount = self?.dataSource?.count
        return view
        }()
    
    lazy var saveBidBtn:UIButton = {[weak self] in
        let btn = UIButton.init(type: .custom)
        btn.setTitle("保存我的竞价", for: .normal)
        
        btn.layer.backgroundColor = UIColor.colorFromHex(0x1ECF8C).cgColor
        btn.addTarget(self, action: #selector(saveBidBtnActoin), for: .touchUpInside)
        btn.setTitleColor(UIColor.white, for: .normal)
        return btn
        }()
    
    func saveBidBtnActoin(){
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "生鲜补货竞价单"
        self.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        self.addChildViewController(childGridTVVC)
        self.view.addSubview(childGridTVVC.view)
        self.view.addSubview(childGridAsideView)
        
        
        self.view.addSubview(self.saveBidBtn)
        self.saveBidBtn.snp.makeConstraints { (make) in
            make.width.left.right.bottom.equalToSuperview()
            make.height.equalTo(40)
        
        }
        
        test()

    }

    func test() {
        let count = self.dataSource!.count
        for i in 0..<count {
            self.childGridAsideView.setValueWith(position: (i, 0), text: "12.0")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    // MARK: - 返回按钮
    override func setBackBarButtonItem() -> UIBarButtonItem {
        
        let backButton = UIButton.init(type: .custom)
        backButton.setImage(UIImage(named: "hlscs_back_arrow"), for: .normal)
        backButton.sizeToFit()
        backButton.frame.size = CGSize(width: 30, height: 30)
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
        return UIBarButtonItem.init(customView: backButton)
    }
    
    override func popBack() {
        _ = self.navigationController?.popViewController(animated: true)
    }


}

extension BiddingVC:GridTVVCDelegate {
    func gridTableViewDidScroll(_ scrollView: UIScrollView) {
        self.childGridAsideView.containerScrollView.contentOffset = scrollView.contentOffset
    }
    
    func gridTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func gridTVVCCellDidClick(btn: UIButton, btnType: GridTVVCCellBtnType, cellIndexPath: IndexPath?) {
        
    }
}



