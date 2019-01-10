//
//  GBLoginViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/7.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBLoginViewController: GBBaseViewController {
    lazy var headImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginHead")
        return imageView
    }()
    lazy var phoneTextField:XKTextField = {
        let textField = XKTextField()
        textField.textColor = kAssistTextColor
        textField.placeholder = "输入手机号"
        textField.font = XKFont.pingFangSCMedium.size(16)
        textField.layer.borderColor = kLineColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 2
        
        return textField
    }()
    lazy var codeTextField:XKTextField = {
        let textField = XKTextField()
        textField.placeholder = "输入验证码"
        textField.textColor = kAssistTextColor
        textField.font = XKFont.pingFangSCMedium.size(16)
        textField.layer.borderColor = kLineColor.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 2
        return textField
    }()
    
    lazy var sendCodeButton:UIButton = {
        let sendCodeButton = UIButton()
        sendCodeButton.setTitle("验证码", for: .normal)
        sendCodeButton.backgroundColor = kBaseColor
        sendCodeButton.titleLabel!.font = XKFont.pingFangSCMedium.size(16)
        sendCodeButton.addTarget(self, action:#selector(sendCodeButtonAction), for: .touchUpInside)
        return sendCodeButton
    }()
    
    lazy var loginButton:UIButton = {
        let loginButton = UIButton()
        loginButton.setImage(UIImage(named: "button_yes"), for: .normal)
        loginButton.addTarget(self, action:#selector(loginButtonAction), for: .touchUpInside)
        
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSnp()
    }
    
    @objc func sendCodeButtonAction() {
        NetworkTool.shared.post(UrlPath.Login_VerificationCode.rawValue, parameters: ["userName":"15120096764"],methodLog:"登录验证码") { (state: ResponseStatus, result: JSON?, message: String?) in
        }
    }
    
    @objc func loginButtonAction() {
        NetworkTool.shared.post(UrlPath.Login.rawValue, parameters: ["userName":"15120096764","smsCode":"1111"],methodLog:"登录") {(state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                let token:String = result!["data"]["token"].string!
                // let userid = JSON!["data"]["id"].float
                GBUserDefaults.set(token, forKey: UDK_UserToken)
                GBUserDefaults.set("\(result!["data"]["id"])", forKey: UDK_UserId)
                GBUserDefaults.synchronize()
                
                KEYWINDOW?.rootViewController = GBMainTabBarControllerViewController()
                GBToolShowMessage("登录成功")
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(headImageView)
        view.addSubview(phoneTextField)
        view.addSubview(codeTextField)
        view.addSubview(sendCodeButton)
        view.addSubview(loginButton)
    }
    
    func addSnp() {
        headImageView.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(GBToolFitUI(222))
        }
        
        phoneTextField.snp.makeConstraints { (make) in
            make.top.equalTo(headImageView.snp.bottom).offset(GBToolFitUI(74))
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.height.equalTo(GBToolFitUI(44))
        }
        
        codeTextField.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(GBToolFitUI(GBMargin))
            make.left.equalTo(60)
            make.right.equalTo(sendCodeButton.snp.left).offset(-10)
            make.height.equalTo(GBToolFitUI(44))
        }
        sendCodeButton.snp.makeConstraints { (make) in
            make.top.equalTo(phoneTextField.snp.bottom).offset(GBToolFitUI(GBMargin))
            make.right.equalTo(-60)
            make.width.equalTo(100)
            make.height.equalTo(GBToolFitUI(44))
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(sendCodeButton.snp.bottom).offset(GBToolFitUI(47))
            make.left.equalTo(60)
            make.right.equalTo(-60)
            make.height.equalTo(GBToolFitUI(44))
        }
    }
}

extension GBLoginViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
