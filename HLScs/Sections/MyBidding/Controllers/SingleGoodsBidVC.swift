//
//  SingleGoodsBidVC.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then
import Alamofire
import SVProgressHUD

enum SingleGoodsBidVCState {
    case fillIn
    case modify
}

class SingleGoosBidResultModel {
    var indexNo:Int?
    var isFinishedBid:Bool?
    var price:String?
    var imagePathArr:[String]?
    var cGoodsNo:String?
    var cSheetNo:String?
    var indexPath:IndexPath?
    
    init(indexNo: Int?, isFinishedBid: Bool?, price: String?, imagePathArr: [String]?, cGoodsNo: String?, cSheetNo: String?) {
        self.indexNo = indexNo
        self.isFinishedBid = isFinishedBid
        self.price = price
        self.imagePathArr = imagePathArr
        self.cGoodsNo = cGoodsNo
        self.cSheetNo = cSheetNo
    }
}

typealias ClosureSingleGoodsBid = (_ model:SingleGoosBidResultModel) -> Void

class SingleGoodsBidVC: BaseVC {

    
    var goodsModel:RepGoodsModel?{
        didSet {
            initialCustomColDataSource()
            self.childGridTVVC.dataSource = [goodsModel!]
        }
    }
    
    var saveClick:ClosureSingleGoodsBid?
    
    var state:SingleGoodsBidVCState? {
        didSet {
            configureTitle()
        }
    }
    var indexNo:Int?
    var indexPath:IndexPath?
    var goodsImagePathArr = [String]()
    var modifyModel:SingleGoosBidResultModel? {
        didSet {
            if let modifyModel = modifyModel {
                //Mark: --- 设置总金额
                var sumCount:Float = 0
                if let fQty = goodsModel?.fQty {
                    sumCount = (fQty as NSString).floatValue
                }
                
                if let text = modifyModel.price {
                    if text.characters.count > 0 {
                        let f = (modifyModel.price! as NSString).floatValue
                        let sum = f * sumCount
                        self.childGridTVVC.customColDataSource = ["\(sum)"]
                        self.childGridTVVC.tableView.reloadData()
                    }
                    
                }
                //Mark: --- 设置单价
                self.priceTF.text = modifyModel.price
                
            }
        }
    }
    
    //Mark: --- 上传图片的按钮buton
    var aUploadBtn:UIButton?
    
    
    //Mark: --- 自定义列的数据源
    var customColDataSource = [String?]()
    
    //Mark: --- views
    
    lazy var childGridTVVC:GridTVVC = {[weak self] in
        let rect = CGRect(x: 0, y: 0, width: WID * 20, height: 80 + kStatusBarH + kNavigationBarH)
        let vc = GridTVVC.init(style: .grouped, titleArr: ["序号", "名称", "编码",  "合计", "总金额"], frame:rect)
        vc.titleWidthWeight = [1, 2, 2, 2, 2]
        vc.dataIndexArray   = [0, 1, 2, 4, 5]
        vc.rowHeight = 45
        vc.tableView.allowsSelection = false
        vc.delegate = self
        vc.cellBgColor = UIColor.white
        return vc
        }()
    
    //Mark: --- 报价控件
    lazy var bidViewBoxView = { ()->UIView in
        let bidview = UIView.init()
        bidview.layer.borderColor = UIColor.colorFromHex(0xcdcdcd).cgColor
        bidview.layer.borderWidth = 0.5
        bidview.backgroundColor   = UIColor.white
        return bidview
    }()
    
    lazy var priceTF = {() -> UITextField in
        let textfield = UITextField.init()
        textfield.keyboardType = UIKeyboardType.decimalPad
        
        textfield.leftViewMode = .always
        
        let asideBtn = UILabel.init()
        asideBtn.frame = CGRect(x: 16, y: 0, width: 60 - 16, height: 60)
        asideBtn.font = font(25)
        asideBtn.textAlignment = .left
        asideBtn.text = "¥"
        asideBtn.baselineAdjustment = .alignBaselines
        textfield.leftView = asideBtn
        
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.textColor = UIColor.black
        textfield.font = font(30)
        
        textfield.backgroundColor = UIColor.white
        return textfield
    }()
    
    var unitLabel:UILabel?
    var uploadImageBtns:UploadImageBtns?
    var saveBtn:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTitle()
        self.navigationItem.leftBarButtonItem = setBackBarButtonItem()
        self.addChildViewController(childGridTVVC)
        self.view.addSubview(childGridTVVC.view)
        self.view.addSubview(bidViewBoxView)
        bidViewBoxView.addSubview(priceTF)
        priceTF.delegate = self
        showNavBackBtn()
        createUI()
        
        self.view.backgroundColor = UIColor.colorFromHex(0xeeeeee)
    }
    
    func createUI() {
        
        uploadImageBtns = UploadImageBtns.init(frame: CGRect.zero).then {
            view.addSubview($0)
            $0.backgroundColor = UIColor.white
            $0.delegate = self
        }
        
        _ = UILabel.init().then {
            $0.text = "单价金额"
            $0.font = font(15)
            $0.frame = CGRect(x: 16, y: 5, width: kScreenW - 30, height: 20)
            bidViewBoxView.addSubview($0)
        }
        
        unitLabel = UILabel.init().then {
            if let cunit = goodsModel?.cUnit {
                $0.text = "元/\(cunit)"
                $0.font = font(15)
                bidViewBoxView.addSubview($0)
            }
        }
        
        saveBtn = UIButton.init(type: .custom).then {
            view.addSubview($0)
            $0.setTitle("保存", for: .normal)
            $0.layer.backgroundColor = UIColor.colorFromHex(0x1ECF8C).cgColor
            $0.addTarget(self, action: #selector(saveBtnAction), for: .touchUpInside)
            $0.setTitleColor(UIColor.white, for: .normal)
        }
    }
    
    var isFinishedUploadImage:Bool?
    
    func saveBtnAction() {
        
            if (priceTF.text?.characters.count)! > 0 {
                
                if let _ = isFinishedUploadImage {
                    //填写完成 
                    //Mark: --- 视图操作
                    if let saveClick = self.saveClick {
                        let model = SingleGoosBidResultModel.init(indexNo: indexNo, isFinishedBid: true, price: priceTF.text, imagePathArr: goodsImagePathArr, cGoodsNo: goodsModel?.cGoodsNo, cSheetNo: goodsModel?.cSheetno)
                            model.indexPath = self.indexPath
                        saveClick(model)
                        popBack()
                    }
                    
                    //Mark: --- 保存至数据库操作
                    
                    
                } else {
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showError(withStatus: "请上传图片")
                }
                
            } else {
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "请填写价格")
            }
            
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        bidViewBoxView.frame = CGRect(x: -1, y: self.childGridTVVC.view.bottom, width: kScreenW + 2, height: 100 + 30)
        
        priceTF.frame = CGRect(x: 1 + 15, y: 20 + 30, width: kScreenW - 30 - 50 - 20, height: 100 - 40)
        
        unitLabel?.frame = CGRect(x: priceTF.right + 10, y: priceTF.bottom - 40, width: 50, height: 40)
        
        uploadImageBtns?.frame  = CGRect(x: 0, y: (bidViewBoxView.bottom) + 30, width: kScreenW, height: WID * 2 + (WID * 15)/4)
        
        saveBtn?.frame = CGRect(x: 0, y: kScreenH - kNavigationBarH - kStatusBarH - 50, width: kScreenW, height: 50)
    }
    
    func initialCustomColDataSource() {
            for _ in 0..<1 {
                self.customColDataSource.append(nil)
            }
            self.childGridTVVC.customColDataSource = self.customColDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func configureTitle() {
        if let state = state {
            switch state {
            case .fillIn:
                self.navigationItem.title = "填写\((goodsModel?.cGoodsName)!)竞价单"
            default:
                self.navigationItem.title = "修改\((goodsModel?.cGoodsName)!)竞价单"
            }
        } else {
            self.navigationItem.title = "填写\((goodsModel?.cGoodsName)!)竞价单"
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
}

extension SingleGoodsBidVC:GridTVVCDelegate {
    func gridTableViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func gridTableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func gridTVVCCellDidClick(btn: UIButton, btnType: GridTVVCCellBtnType, cellIndexPath: IndexPath?) {
        
    }
}


extension SingleGoodsBidVC:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.text!)
        var sumCount:Float = 0
        if let fQty = goodsModel?.fQty {
            sumCount = (fQty as NSString).floatValue
        }
        
        if let text = textField.text {
            if text.characters.count > 0 {
                let f = (textField.text! as NSString).floatValue
                let sum = f * sumCount
                self.childGridTVVC.customColDataSource = ["\(sum)"]
                self.childGridTVVC.tableView.reloadData()
            }
        
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}



extension SingleGoodsBidVC:UploadImageBtnsDelegate {
    func uploadImageBtnsDidClicked(sender: UIButton, completeionHandler: (Bool) -> Void) {
        self.aUploadBtn = sender
        //Mark: --- 上传图片
        let alertVC = UIAlertController.init(title: "上传图像", message: nil, preferredStyle: .actionSheet)
        
        let albumAction = UIAlertAction.init(title: "相机", style: .default) {
            (action:UIAlertAction) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.allowsEditing = true
                picker.delegate = self
                self.present(picker, animated: true, completion: nil)
                
            } else {
                print("模拟其中无法打开照相机,请在真机中使用")
            }
            
        }
        
        let cameraAction = UIAlertAction.init(title: "相册", style: .default) {
            (action: UIAlertAction) -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction.init(title: "取消", style: .cancel) { (UIAlertAction) in
            
        }
        
        alertVC.addAction(albumAction)
        alertVC.addAction(cameraAction)
        alertVC.addAction(cancelAction)
        
        self.navigationController?.present(alertVC, animated: true, completion: {
            
        })

        
    }
}

extension SingleGoodsBidVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents"
            
            let fileManager = FileManager.default
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                print(error)
            }
          
            
            //Mark: --- 压缩图片大小
            let size = CGSize(width: 80, height: 80)
            let desImage = image.reSizeImage(reSize: size)
            
            let cSupNo:String = userDefault.object(forKey: userDefaultUserIDKey) as! String
            let cGoodsNo = goodsModel?.cGoodsNo
            let imageName = "\(cSupNo)_\(cGoodsNo!)"
            let imageData = UIImagePNGRepresentation(desImage)
            let imagePath = documentPath+"/\(imageName).png"
            print(imagePath)
            fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
            let filePath: String = String(format: "%@%@", documentPath, "/\(imageName).png")
                
                
            let cSupNoData      = cSupNo.data(using: .utf8)
            let cGoodsNoData    = cGoodsNo?.data(using: .utf8)
                
            if  let cSupNoData   = cSupNoData,
                let cGoodsNoData = cGoodsNoData{
                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                        //let lastData = NSData(contentsOfFile: filePath)
                        multipartFormData.append(URL.init(fileURLWithPath: filePath), withName: "\(imageName)")
                        multipartFormData.append(cGoodsNoData, withName: "cGoodsNo")
                        multipartFormData.append(cSupNoData, withName: "cSpuer_No")
                    }, to: "\(defaultURL)/YingYunTong/Upload_Goods_Image", encodingCompletion: { (result) in
                        SVProgressHUD.setMaximumDismissTimeInterval(1)
                        SVProgressHUD.showSuccess(withStatus: "上传成功!")
                        self.isFinishedUploadImage = true
                        
                        //Mark: --- 如果图片按钮点击两次会上传两次, 所以要确定图片是修改还是增加, 就是根据button的tag值来决定是否修改, 可以预设数组的个数, 以及值为4
                        self.goodsImagePathArr.append(imagePath)
                        DispatchQueue.main.async(execute: { 
                        self.aUploadBtn?.setImage(UIImage.init(contentsOfFile: imagePath), for: .normal)
                        })
                    })
                }
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
}

extension UIImage {
    /**
     *  重设图片大小
     */
    func reSizeImage(reSize:CGSize)->UIImage {
        //UIGraphicsBeginImageContext(reSize);
        UIGraphicsBeginImageContextWithOptions(reSize,false,UIScreen.main.scale);
        self.draw(in: CGRect(x:0, y:0, width:reSize.width, height:reSize.height));
        
        let reSizeImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        return reSizeImage;
    }
    
    /**
     *  等比率缩放
     */
    func scaleImage(scaleSize:CGFloat)->UIImage {
        let reSize = CGSize(width:self.size.width * scaleSize, height:self.size.height * scaleSize)
        return reSizeImage(reSize: reSize)
    }
}





