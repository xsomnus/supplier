//
//  CheckNewGoodsRequestVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/14.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON
import Moya
import Then
import SVProgressHUD


enum NewGoodsShowState {
    case list
    case grid
}

class CheckNewGoodsRequestVC: BaseVC {

    let provider = MoyaProvider<ApiManager>()
    var dataSource : [NewGoodsRequestModel]?
    
    var state:NewGoodsShowState = .list
    
    lazy var flowLayout = { () -> UICollectionViewFlowLayout in
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize(width: kScreenW - 20, height: HEI * 3.5)
        flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10)
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        return flowLayout
    }()
    
    
    lazy var goodListView:UICollectionView = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH )
        let view = UICollectionView.init(frame: rect, collectionViewLayout: (self?.flowLayout)!)
        view.delegate = self
        view.dataSource = self
        return view
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.navigationItem.title = "我的新品推荐"
        requestData()
        setupUI()
        goodListView.register(CheckNewGoodsListCell.self, forCellWithReuseIdentifier: "collectionListCellID")
        goodListView.register(CheckNewGoodsGridCell.self, forCellWithReuseIdentifier: "collectionGridCellID")
        goodListView.backgroundColor = UIColor.colorFromHex(0xefefef)
        initRightBarButtonItem()

    }
    
    var rightBtn:UIButton?
    
    func initRightBarButtonItem() {
        self.rightBtn = UIButton.init(type: .custom)
        rightBtn?.setImage(UIImage.init(named: "hlscs_newgoods_grid")?.withRenderingMode(.alwaysOriginal), for: .normal)
        rightBtn?.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightBtn?.addTarget(self, action: #selector(changeShowWay), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn!)
    }
    
    
    
    func changeShowWay() {
        switch state {
            case .list :
                self.flowLayout.itemSize = CGSize(width: (kScreenW - 25)/2 , height: HEI * 8)
                rightBtn?.setImage(UIImage.init(named: "hlscs_newgoods_list")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.state = .grid
                self.goodListView.layoutIfNeeded()
                self.goodListView.reloadData()
            case .grid:
                self.flowLayout.itemSize = CGSize(width: kScreenW - 20, height: HEI * 3.5)
                rightBtn?.setImage(UIImage.init(named: "hlscs_newgoods_grid")?.withRenderingMode(.alwaysOriginal), for: .normal)
                self.state = .list
                self.goodListView.layoutIfNeeded()
                self.goodListView.reloadData()
            }
    }
    
    func setupUI() {
        self.view.addSubview(goodListView)
    }

    func requestData() {
        SVProgressHUD.show()
        provider.request(.URL_Select_New_Products("1001")) { (result) in
            switch result {
            case let .success(response):
                do {
                    self.dataSource = try response.mapArray(NewGoodsRequestModel.self)
                    SVProgressHUD.dismiss(withDelay: 1, completion: { 
                        self.goodListView.reloadData()
                    })
                } catch {
                    SVProgressHUD.dismiss(withDelay: 1)
                }
            case let .failure(error):
                SVProgressHUD.dismiss(withDelay: 1, completion: { 
                    print(error)
                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    

 }

extension CheckNewGoodsRequestVC:UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataSource = self.dataSource {
            return dataSource.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch state {
            case .list:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionListCellID", for: indexPath) as! CheckNewGoodsListCell
                cell.backgroundColor = UIColor.white
                cell.goodsModel = self.dataSource?[indexPath.row]
                return cell
            case .grid:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionGridCellID", for: indexPath) as! CheckNewGoodsGridCell
                cell.backgroundColor = UIColor.white
                cell.goodsModel = self.dataSource?[indexPath.row]
                return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        UIView.animate(withDuration: 0.6) { 
            cell.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
}











