//
//  NewGoodsRequest.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/12.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import Then
import SVProgressHUD
import Moya
import SwiftyJSON
import Alamofire


class NewGoodsRequestVC1: BaseVC {
    
    let provider = MoyaProvider<ApiManager>()
    
    var isAddFooterHeight:Bool = false
    var aUploadBtn:UIButton?
    var imageFilePath:String?
    var imageName:String?
    
    var dataSource = ["商品名称", "条码", "商品规格", "商品单位", "现有存货", "我的竞价", "申请人", "联系方式", "公司名称", "备注"]
    
    
    lazy var scrollFormView:ScrollFormView = { [weak self] in
        let rect = CGRect(x: -1, y: 0, width: kScreenW + 2, height: kScreenH - 20 - kNavigationBarH - kStatusBarH)
        let scrollFormView:ScrollFormView = ScrollFormView.init(frame: rect, titleDataSource: (self?.dataSource)!, tfDelegate: self!) { tfArray in
                
            }
        scrollFormView.backgroundColor = UIColor.white
        scrollFormView.layer.borderColor = UIColor.colorFromHex(0xcdcdcd).cgColor
        scrollFormView.layer.borderWidth = 0.5
        scrollFormView.delegate = self
        scrollFormView.uploadImageBtns?.delegate = self
        return scrollFormView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showNavBackBtn()
        self.navigationItem.title = "填写新品申请单"
        self.view.addSubview(scrollFormView)
        self.view.backgroundColor = UIColor.colorFromHex(0xededed)
        
        //Mark: --- 注册键盘通知
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //键盘的出现
    func keyBoardWillShow(_ notification: Notification){
        //获取userInfo
        let kbInfo = notification.userInfo
        //获取键盘的size
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let changeY = kbRect.size.height + 15
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -changeY)
            self.scrollFormView.containerScrollView.frame = CGRect(x: 0, y: changeY, width: kScreenW + 2, height: kScreenH - kNavigationBarH - kStatusBarH - changeY - 20)

        }
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        _ = kbRect.size.height + 15
        
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            self.scrollFormView.containerScrollView.frame = CGRect(x: 0, y: 0, width: kScreenW + 2, height: kScreenH - 20 - kNavigationBarH - kStatusBarH)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension NewGoodsRequestVC1:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension NewGoodsRequestVC1:ScrollFormViewDelegate {
    func ScrollFormViewDidCommit(titles: [String]?, tfArray: [UITextField]?) {
        var tmpValuesArr = [String]()
        if let titles = titles,
            let tfArray = tfArray {
            for i in 0..<titles.count {
                if let text = tfArray[i].text {
                    if text.characters.count == 0 {
                    
                        SVProgressHUD.setMaximumDismissTimeInterval(1)
                        SVProgressHUD.showError(withStatus: "\(titles[i])不能为空")
                        return
                    } else {
                        tmpValuesArr.append(text)
                    }
                } else {
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showError(withStatus: "\(titles[i])不能为空")
                    return
                }
            }
        } else {
            SVProgressHUD.setMaximumDismissTimeInterval(1)
            SVProgressHUD.showError(withStatus: "数据解析出现问题")
        }
        
        if self.imageFilePath?.characters.count == 0 || self.imageFilePath == nil {
            SVProgressHUD.setMaximumDismissTimeInterval(1)
            SVProgressHUD.showError(withStatus: "请上传海报图")
            return
        }
        
        //Mark: --- 以上是对错误情况的进行判断, 下面就是传递数据
        var dic = [String : String]()
        dic["cGoodsName"] = tmpValuesArr[0]
        dic["cBarcode"]   = tmpValuesArr[1]
        dic["cUnit"]   = tmpValuesArr[3]
        dic["cSpec"]   = tmpValuesArr[2]
        dic["num"]   = tmpValuesArr[4]
        dic["Price"]   = tmpValuesArr[5]
        dic["Tel"]   = tmpValuesArr[7]
        dic["Applicant"]   = tmpValuesArr[6]
        //根据本地存储的userDefaults来取
        dic["cSupNo"]   = tmpValuesArr[1]
        dic["Image_Path"]   = self.imageName
        
        let json = JSON.init(rawValue: dic)!
        print(json) 
       
        
        
        provider.request(.URL_Upload_New_Products(json)) { (result) in
            switch result {
            case let .success(response):
                let json = JSON(response.data)
                print(json)
            case let .failure(error):
                print(error)
            }
        }
        
    }
}


extension NewGoodsRequestVC1:UploadImageBtnsDelegate {
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

extension NewGoodsRequestVC1:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
            
            let cSupNo = userDefault.object(forKey: userDefaultUserIDKey)
            let imageName = "\(cSupNo as! String)"
            let imageData = UIImagePNGRepresentation(desImage)
            let imagePath = documentPath+"/\(imageName).png"
            print(imagePath)
            fileManager.createFile(atPath: imagePath, contents: imageData, attributes: nil)
            let filePath: String = String(format: "%@%@", documentPath, "/\(imageName).png")
            self.imageFilePath = filePath
            self.imageName = "\(imageName).png"
            self.aUploadBtn?.setImage(UIImage.init(contentsOfFile: filePath), for: .normal)
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
    
    
}
