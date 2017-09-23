//
//  NextRegisterVC.swift
//  HLMarketV1.0
//
//  Created by @xwy_brh on 10/03/2017.
//  Copyright © 2017 @egosuelee. All rights reserved.
//

import UIKit
import SwiftyJSON

class NextRegisterVC: BaseViewController,UITextFieldDelegate {

    lazy var topBoxView = {UIView.init()}()
    
    var tel:String? = nil
    
    lazy var pwdTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 30)
        let label = UILabel.init(frame:rect)
        label.text = "密码"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        //定义textfield的样式
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请输入密码"
        textfield.font = UIFont.systemFont(ofSize: 14)
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.isSecureTextEntry = true
        
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    
    lazy var confirmPwdTF = {() -> UITextField in
        let textfield = UITextField.init()
        let rect = CGRect(x: 0, y: 0, width: 60, height: 30)
        let label = UILabel.init(frame:rect)
        label.text = "确认密码"
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = NSTextAlignment.center
        
        textfield.leftViewMode = UITextFieldViewMode.always
        textfield.leftView = label
        
        textfield.layer.borderColor = UIColor.init(gray: 234).cgColor
        textfield.layer.borderWidth = 1
        textfield.placeholder = "请再次输入密码"
        textfield.isSecureTextEntry = true
        textfield.clearButtonMode = UITextFieldViewMode.always
        textfield.font = UIFont.systemFont(ofSize: 14)
        
        textfield.backgroundColor = UIColor.white
        textfield.keyboardType = .numberPad
        return textfield
    }()
    
    lazy var selectStoreBtn = {() -> UIButton in
        let btn = UIButton.init()
        btn.layer.borderColor = UIColor.init(gray: 234).cgColor
        btn.layer.borderWidth = 1
        btn.setTitle("请选择您的服务门店", for: UIControlState.normal)
        btn.setTitleColor(UIColor.appMainColor(), for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    
    lazy var botBoxView = {UIView.init()}()
    
    lazy var registerBtn = {() -> UIButton in
        let btn = UIButton.init(type: UIButtonType.custom)
        btn.setTitle("注册", for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        btn.layer.backgroundColor = UIColor.appMainColor().cgColor
        
        return btn
    }()
    
    fileprivate var selectStoreState = false
    
    fileprivate var storeNo = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.init(gray: 252)
        
        self.navigationItem.title = "密码设置"
        self.registerBtn.addTarget(self, action: #selector(NextRegisterVC.registerAction), for: .touchUpInside)
        
        self.setupUI()
        self.layoutUI()
    }

    func registerAction() {
        
        pwdTF.resignFirstResponder()
        confirmPwdTF.resignFirstResponder()
        
        if pwdTF.text == nil || confirmPwdTF.text == nil {
            showHint(in: view, hint: "密码不能为空")
            return
        }
        
        if pwdTF.text != confirmPwdTF.text {
            showHint(in: view, hint: "密码不一致!")
            return
        }
        
        if selectStoreState == false {
            showHint(in: view, hint: "请选择一个店铺")
            return
        }
        
        registerBtn.isUserInteractionEnabled = false
        
        showHud(in: view)
        
        do {
            let pattern = "^\\d{6}$"
            let validateString = pwdTF.text!
            
            let regex: NSRegularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: validateString, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, validateString.characters.count))
            if matches.count > 0 {
                //网络请求, 进行注册
                AlamofireNetWork.required(urlString: "/Simple_online/User_Register", method: .post, parameters: ["Tel":self.tel!, "PassWord":pwdTF.text!.md5String(),"cStoreNo":storeNo], success: { (results) in
                    
                    let json = JSON(results)
                    
                    if json["resultStatus"] == "1" {
                        self.showHint(in: self.view, hint: "注册成功")
                        
                        //保存用户信息
                        DispatchQueue_AfterExecute(delay: 2, blok: {
                            let loginVc:LoginViewController = (self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)!-3]) as! LoginViewController
                            loginVc.autoLoginDicSetting = ["Tel":self.tel!, "PassWord":self.pwdTF.text!.md5String()]
                            _ = self.navigationController?.popToViewController(loginVc, animated: true)
                        })
                    }else {
                        self.registerBtn.isUserInteractionEnabled = true
                        self.showHint(in: self.view, hint: "注册失败")
                    }
                    
                }, failure: { (error) in
                    self.hideHud()
                    self.registerBtn.isUserInteractionEnabled = true
                })
                
            } else {
                registerBtn.isUserInteractionEnabled = true
                showHint(in: view, hint: "密码必须为6位数字密码")
            }
        }
        catch {
            hideHud()
            registerBtn.isUserInteractionEnabled = true
        }
    
        
    }
    
    func selectStoreBtnAction() -> Void {
        let vc = ChooseStoreAddressVC()
        vc.chooseFinished = {[weak self] (store)->Void in
            self?.selectStoreState = true
            self?.selectStoreBtn.setTitle(store.cStoreName, for: UIControlState.normal)
            self?.storeNo = store.cStoreNo
        }
        _ = self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupUI() {
        view.addSubview(topBoxView)
        topBoxView.addSubview(pwdTF)
        pwdTF.delegate = self
        topBoxView.addSubview(confirmPwdTF)
        confirmPwdTF.delegate = self
        topBoxView.addSubview(selectStoreBtn)
        selectStoreBtn.addTarget(self, action: #selector(selectStoreBtnAction), for: .touchUpInside)
        
        view.addSubview(botBoxView)
        botBoxView.addSubview(registerBtn)
        
    }
    
    func layoutUI() {
        
        topBoxView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self.view).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(158)
        }
        
        pwdTF.snp.makeConstraints { (make) in
            make.top.left.equalTo(topBoxView).offset(5)
            make.height.equalTo(confirmPwdTF)
            make.right.equalTo(-5)
            make.bottom.equalTo(confirmPwdTF.snp.top).offset(-5)
        }
        
        confirmPwdTF.snp.makeConstraints { (make) in
            //make.top.equalTo(userTF.snp.bottom).offset(5)
            make.bottom.equalTo(selectStoreBtn.snp.top).offset(-5)
            make.left.right.equalTo(pwdTF)
            make.height.equalTo(pwdTF)
        }
        
        selectStoreBtn.snp.makeConstraints { (make) in
            //make.top.equalTo(userTF.snp.bottom).offset(5)
            make.bottom.equalTo(topBoxView.snp.bottom).offset(-5)
            make.left.right.equalTo(pwdTF)
            make.height.equalTo(confirmPwdTF)
        }
        
        botBoxView.snp.makeConstraints { (make) in
            make.centerX.equalTo(topBoxView)
            make.width.equalTo(topBoxView)
            make.top.equalTo(topBoxView.snp.bottom).offset(10)
            make.bottom.equalTo(self.view).offset(-20)
        }
        
        registerBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(botBoxView)
            make.width.equalTo(botBoxView).multipliedBy(0.8)
            make.top.equalTo(botBoxView).offset(5)
            make.height.equalTo(pwdTF.snp.height)
        }
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == pwdTF {
            confirmPwdTF.becomeFirstResponder()
        }else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

}
