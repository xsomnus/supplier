//
//  MainLoginVC.swift
//  HLScs
//
//  Created by @xwy_brh on 29/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SnapKit
import Moya
import SwiftyJSON
import SVProgressHUD


class MainLoginVC: BaseVC {

    lazy var logoView = {() -> UIImageView in
        let imageView = UIImageView.init(image: UIImage.init(named: "hlscs_logo"))
        return imageView
    }()
    
    lazy var tfBoxView = {() -> UIView in
        let view = UIView.init()
        view.backgroundColor = UIColor.white
        view.layer.borderColor = UIColor.colorFromHex(0xD3D3D3).cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var userTF = {() -> UITextField in
        let textfield = UITextField.init()
        textfield.keyboardType = UIKeyboardType.numberPad
        
        textfield.leftViewMode = .always
        
        let asideBtn = UIButton.init(type: .custom)
        asideBtn.setImage(UIImage.init(named: "hlscs_userphone"), for: .normal)
        asideBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        
        textfield.leftView = asideBtn
        
        textfield.placeholder = "请输入手机号"
        textfield.textColor = UIColor.init(gray: 232)
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.font = font(18)

        return textfield
    }()

    lazy var pwdTF = {() -> UITextField in
        let textfield = UITextField.init()
        textfield.isSecureTextEntry = true
       
        textfield.leftViewMode = .always
        let asideBtn = UIButton.init(type: .custom)
        asideBtn.setImage(UIImage.init(named: "hlscs_pwd"), for: .normal)
        asideBtn.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        textfield.leftView = asideBtn
        
        textfield.placeholder = "请输入密码"
        textfield.textColor = UIColor.init(gray: 232)
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.font = font(18)

        return textfield
    }()
    
    lazy var userSepLineView = {() -> UIView in
        let view = UIView.init()
        view.backgroundColor = UIColor.colorFromHex(0xe3e3e3)
        return view
    }()
    
    
    lazy var loginBtn = {() -> MainLoginBtn in
        let btn = MainLoginBtn(type: .custom)
        
        btn.setTitle("登录", for: .normal)
        btn.layer.backgroundColor = UIColor.colorFromHex(UInt32(0x007AFF)).cgColor
        btn.layer.borderColor     = UIColor.colorFromHex(UInt32(0x006DE5)).cgColor
        btn.layer.borderWidth     = 1
        btn.layer.cornerRadius    = 3
        btn.layer.masksToBounds   = true
        return btn
    }()
    
    
    var isLoginPercommit:Bool? {
        didSet {
            if isLoginPercommit! {
                self.loginBtn.isEnabled = true
                self.loginBtn.alpha = 1
            } else {
                self.loginBtn.isEnabled = false
                self.loginBtn.alpha = 0.4
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.view.backgroundColor = UIColor.colorFromHex(0xf4f4f4)
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
        //键盘的y偏移量
        let max_Y = kScreenH - self.loginBtn.y - self.loginBtn.height
        let changeY = kbRect.size.height - max_Y + 15
        //键盘弹出的时间
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: -changeY)
        }
    }
    
    //键盘的隐藏
    func keyBoardWillHide(_ notification: Notification){
        
        let kbInfo = notification.userInfo
        let kbRect = (kbInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let max_Y = kScreenH - self.loginBtn.y - self.loginBtn.height
        _ = kbRect.size.height - max_Y - 15
        
        let duration = kbInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        
        //界面偏移动画
        UIView.animate(withDuration: duration) {
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //隐藏navgationBar
        self.navigationController?.navigationBar.isHidden = true
        pwdTF.delegate = self
        userTF.delegate = self
    }
    
    func loginAction(sender:UIButton) {
        
        if userTF.text?.characters.count == 0 {
            SVProgressHUD.setMaximumDismissTimeInterval(1)
            SVProgressHUD.show(nil, status: "账户名不能为空")
            return
        }
        
        if pwdTF.text?.characters.count == 0 {
            SVProgressHUD.show(nil, status: "密码不能为空")
            return
        }
        
        SVProgressHUD.show()
        let provider = MoyaProvider<ApiManager>()
        provider.request(ApiManager.URL_Login(userTF.text!, pwdTF.text!)) { (result) in
            switch result {
            case let .success(response):
                let statusCode = response.statusCode
                let data = response.data
                if statusCode == 200 {
                    let json = JSON(data)
                    if json["resultStatus"] == "1" {
                        //Mark: --- 将UserID存在本地
                        userDefault.set(json["dDate"].string, forKey: userDefaultUserIDKey)
                        let homeVC = HomeVC()
                        self.navigationController?.pushViewController(homeVC, animated: true)
                        SVProgressHUD.dismiss()
                        return
                    } else {
                        SVProgressHUD.setMaximumDismissTimeInterval(1)
                        SVProgressHUD.showError(withStatus: "账户名/密码错误.")
                        return
                    }
                }
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "网络连接中断")
            case let .failure(error):
                print(error)
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "网络连接中断")
            }
        }
        /*
        let homeVC = HomeVC()
        self.navigationController?.pushViewController(homeVC, animated: true)
         */
    }
    
    //MARK: --- 创建视图, 添加视图, 布局视图
    func setupUI() {
        self.view.addSubview(logoView)
        self.view.addSubview(tfBoxView)
        tfBoxView.addSubview(userTF)
        tfBoxView.addSubview(pwdTF)
        tfBoxView.addSubview(userSepLineView)
        self.view.addSubview(loginBtn)
        self.loginBtn.addTarget(self, action: #selector(loginAction(sender:)), for: .touchUpInside)
        //self.isLoginPercommit = false
       
        let imageRatio:CGFloat = 148/490
        logoView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(kGoldRatio)
            make.height.equalTo(logoView.snp.width).multipliedBy(imageRatio)
        }
        
        tfBoxView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(-1)
            make.right.equalToSuperview().offset(1)
            make.top.equalTo(logoView.snp.bottom).offset(65)
            make.height.equalTo(HEI*4)
        }
        
        userTF.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(2)
            make.height.equalTo(tfBoxView.snp.height).offset(-11).dividedBy(2)
            make.top.equalToSuperview().offset(5)
        }
        userSepLineView.snp.makeConstraints { (make) in
            //make.width.centerX.equalTo(userTF)
            make.left.equalTo(userTF).offset(30)
            make.right.equalTo(userTF)
            make.height.equalTo(1)
            make.top.equalTo(userTF.snp.bottom).offset(5)
        }
        
        pwdTF.snp.makeConstraints { (make) in
            make.centerX.width.height.equalTo(userTF)
            make.top.equalTo(userSepLineView.snp.bottom).offset(5)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalTo(pwdTF.snp.width).multipliedBy(0.8)
            make.height.equalTo(loginBtn.snp.width).dividedBy(6)
            make.top.equalTo(tfBoxView.snp.bottom).offset(35)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}



extension MainLoginVC:UITextFieldDelegate {
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


