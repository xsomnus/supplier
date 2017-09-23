//
//  DatePickerBtn.swift
//  HLScs
//
//  Created by @xwy_brh on 2017/4/15.
//  Copyright © 2017年 @egosuelee. All rights reserved.
//

import UIKit
import FSCalendar
import Then
import SVProgressHUD

enum DatePickerBtnFSCalendarState {
    case startDate
    case endDate
}
protocol DatePickerBtnDelegate {
    func datePickerBtnDidCommit(startDate:String, endDate:String)
}

class DatePickerBtn: UIView {
    
    
    var startDate:String?
    var endDate:String?
    var delegate:DatePickerBtnDelegate?
    
    lazy var datePickerBtn:UIButton = {[weak self] in
        let datePickerBtn = UIButton.init(frame: (self?.bounds)!)
        datePickerBtn.backgroundColor = UIColor.colorFromHex(0xF8F8F8)
        datePickerBtn.setImage(UIImage.init(named: "hlscs_calendar_icon"), for: .normal)
        datePickerBtn.setTitleColor(UIColor.colorFromHex(0x111111), for: .normal)
        return datePickerBtn
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBtn()
        self.addSubview(datePickerBtn)
        datePickerBtn.addTarget(self, action: #selector(chooseDateAction), for: .touchUpInside)
    }
    
    var maskViewArr = [UIView]()
    
    
    func tapWhiteSpaceAction() {
        DatePickerBtn.fsCalendar.removeFromSuperview()
    }
    
    func chooseDateAction() {
        
        let bgMaskView = UIView.init(frame: CGRect(x: 0, y: kNavigationBarH + kStatusBarH, width: kScreenW, height: kScreenH - kNavigationBarH - kStatusBarH))
        bgMaskView.alpha = 0.6
        bgMaskView.layer.backgroundColor = UIColor.colorFromHex(0x010101).cgColor
        let tap = UITapGestureRecognizer()
        tap.addTarget(self, action: #selector(tapWhiteSpaceAction))
        bgMaskView.addGestureRecognizer(tap)
        
        let containerView = UIView.init(frame: CGRect(x: 15, y: kNavigationBarH + kStatusBarH + 50, width: kScreenW - 30, height: 180))
       
        containerView.backgroundColor = UIColor.white
        UIApplication.shared.keyWindow?.addSubview(bgMaskView)
        UIApplication.shared.keyWindow?.addSubview(containerView)
        maskViewArr.append(bgMaskView)
        maskViewArr.append(containerView)
        
        let cancelBtn = UIButton.init(frame: CGRect(x: kScreenW - 30 - 40, y: 0, width: 40, height: 40))
        cancelBtn.setImage(UIImage.init(named: "hlscs_cancel_icon"), for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.addTarget(self, action: #selector(dismissDataChooseView), for: .touchUpInside)
        containerView.addSubview(cancelBtn)
        containerView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        let titleLabel = UILabel.init(frame: CGRect(x: 15, y: 10, width: kScreenW - 85, height: 30))
        titleLabel.text = "自定义时间"
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.baselineAdjustment = .alignCenters
        containerView.addSubview(titleLabel)
        
        _ = UILabel.init(frame: CGRect(x: 30, y: 50, width: (kScreenW - 90)/3, height: 30)).then{
            containerView.addSubview($0)
            $0.text = "开始时间:"
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 15)
        }
        
        let startDateBtn = UIButton.init(type: .custom).then{
            containerView.addSubview($0)
            $0.frame = CGRect(x: 30 + (kScreenW - 90)/3, y: 50, width: ((kScreenW - 90)/3)*2, height: 30)
            $0.layer.borderColor = UIColor.colorFromHex(0xe7e7e7).cgColor
            $0.layer.cornerRadius = 3
            $0.tag = 0
            $0.layer.borderWidth = 0.5
            $0.setTitle("\(self.startDate!)", for: .normal)
            $0.setTitleColor(UIColor.colorFromHex(0x2C2C2C), for: .normal)
            //$0.setImage(UIImage.init(named: "hlscs_pulldown_calendar"), for: .normal)
            }
        
        _ = UILabel.init(frame: CGRect(x: 30, y: 90, width: (kScreenW - 90)/3, height: 30)).then{
            containerView.addSubview($0)
            $0.text = "结束时间:"
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 15)
        }

        let endDateBtn = UIButton.init(type: .custom).then{
            containerView.addSubview($0)
            $0.frame = CGRect(x: 30 + (kScreenW - 90)/3, y: 90, width: ((kScreenW - 90)/3)*2, height: 30)
            $0.layer.borderColor = UIColor.colorFromHex(0xe7e7e7).cgColor
            $0.layer.cornerRadius = 3
            $0.layer.borderWidth = 0.5
            $0.tag = 1
            $0.setTitle("\(self.endDate!)", for: .normal)
            $0.setTitleColor(UIColor.colorFromHex(0x2C2C2C), for: .normal)
            //$0.setImage(UIImage.init(named: "hlscs_pulldown_calendar"), for: .normal)
        }

        _ = UIButton.init(type: .custom).then{
            containerView.addSubview($0)
            $0.frame = CGRect(x: 50, y: 130, width: kScreenW - 30 - 100, height: 40)
            $0.setTitle("确定", for: .normal)
            $0.layer.cornerRadius = 3
            $0.layer.backgroundColor = UIColor.appMainColor().cgColor
            $0.addTarget(self, action: #selector(commitDate), for: .touchUpInside)
        }
        
        startDateBtn.addTarget(self, action: #selector(chooseDateFromFS(sender:)), for: .touchUpInside)
        endDateBtn.addTarget(self, action: #selector(chooseDateFromFS(sender:)), for: .touchUpInside)
        
        UIView.animate(withDuration: 0.5) {
            containerView.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func commitDate() {
        if let delegate = delegate {
            delegate.datePickerBtnDidCommit(startDate: self.startDate!, endDate: self.endDate!)
        }
        setBtnTitle(startDate: self.startDate!, endDate: self.endDate!)
        dismissDataChooseView()
    }
    
    static let fsCalendar = FSCalendar.init(frame: CGRect(x: 0, y: kScreenH - 300, width: kScreenW, height: 300)).then {
        $0.backgroundColor = UIColor.white
        $0.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
    }
    
    var fsCalendarState:DatePickerBtnFSCalendarState = .startDate
    var fsBtn:UIButton?
    func chooseDateFromFS(sender:UIButton) {
        if let fsBtn = self.fsBtn {
            fsBtn.layer.borderColor = UIColor.colorFromHex(0xe7e7e7).cgColor
            fsBtn.setTitleColor(UIColor.colorFromHex(0x2C2C2C), for: .normal)
        }
        fsBtn = sender
        fsBtn?.layer.borderColor = UIColor.appMainColor().cgColor
        fsBtn?.setTitleColor(UIColor.appMainColor(), for: .normal)
        switch sender.tag {
        case 0:
            fsCalendarState = .startDate
        default:
            fsCalendarState = .endDate
        }
        UIApplication.shared.keyWindow?.addSubview(DatePickerBtn.fsCalendar)
        DatePickerBtn.fsCalendar.delegate = self
        UIView.animate(withDuration: 0.5) {
            DatePickerBtn.fsCalendar.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    func dismissDataChooseView() {
        _ = maskViewArr.map{
            $0.removeFromSuperview()
        }
        DatePickerBtn.fsCalendar.removeFromSuperview()
    }
    
    deinit {
        dismissDataChooseView()
    }
    
    func configureBtn() {
        if  let startDate = self.startDate,
            let endDate   = self.endDate {
            datePickerBtn.setTitle("\(startDate) 至 \(endDate)", for: .normal)
        } else {
            self.startDate = NSDate.getToday()
            self.endDate   = NSDate.getToday()
            datePickerBtn.setTitle("\(NSDate.getToday()!) 至 \(NSDate.getToday()!)", for: .normal)
        }
    }
    
    func setBtnTitle(startDate:String, endDate:String) {
        self.startDate = startDate
        self.endDate   = endDate
        configureBtn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension DatePickerBtn:FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        switch fsCalendarState {
        case .startDate:
            let endDateFormat = self.endDate?.toDate()
            if date.timeIntervalSince(endDateFormat!) <= 0 {
                if date.timeIntervalSince(Date()) <= 0 {
                    self.startDate = date.toString()
                } else {
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showError(withStatus: "开始日期不能大于今天")
                    return
                }
            } else {
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "开始日期不能大于结束日期")
                return
            }
        default:
            let startDateFormat = self.startDate?.toDate()
            if date.timeIntervalSince(startDateFormat!) >= 0 {
                if date.timeIntervalSince(Date()) <= 0 {
                    self.endDate = date.toString()
                    } else {
                    SVProgressHUD.setMaximumDismissTimeInterval(1)
                    SVProgressHUD.showError(withStatus: "结束日期不能大于今天")
                    return
                }
            } else {
                SVProgressHUD.setMaximumDismissTimeInterval(1)
                SVProgressHUD.showError(withStatus: "结束日期不能小于开始日期")
                return
            }
            
        }
        if let fsBtn = fsBtn {
            fsBtn.setTitle(date.toString(), for: .normal)
        }
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        
    }
}

