//
//  GBPersonalInfoViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/1.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBPersonalInfoViewController: GBBaseViewController {
    lazy var titles:[[String]] = [["点击上传头像"],["昵称","性别","个性签名"],["职业","年龄","星座"]]
    var headImageView = UIImageView()
    var userInfoModel = GBUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = "个人资料"
        setupUI()
    }
    
    deinit {
        
    }
}

extension GBPersonalInfoViewController {
    func setupUI() {
        navBar.wr_setRightButton(title: "保存", titleColor: kBaseColor)
        navBar.onClickRightButton = {
           let param = [
                "nickName":self.userInfoModel.nickName,
                "headImg":self.userInfoModel.headImg,
                "signature":self.userInfoModel.signature,
                "sex":self.userInfoModel.sex,
                "age":self.userInfoModel.age,
                "occupation":self.userInfoModel.occupation,
                "constellation":self.userInfoModel.constellation
            ]
            
            NetworkTool.shared.post(UrlPath.MineInfoUpdate.rawValue, parameters: param as [String : Any], methodLog: "更新个人信息", finished: { (state: ResponseStatus, result: JSON?, message: String?) in
                if state == .success {
                    GBToolShowMessage("更新成功")
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        
        baseTableView.delegate = self
        baseTableView.dataSource = self
        baseTableView.sectionHeaderHeight = 8
        baseTableView.sectionFooterHeight = 0.000001
        baseTableView.mj_header = nil
        baseTableView.mj_footer = nil
        baseTableView.register(GBSexSettingCell.self, forCellReuseIdentifier: "GBSexSettingCell")
        view.addSubview(baseTableView)
        view.backgroundColor = UIColor.ColorFromHexStr(hexString: "#F5F5F5")
        baseTableView.backgroundColor = view.backgroundColor
    }
    
    @objc func loginOutAction() {
        GBLog("退出登录")
    }
    
    func changeUerHeadImage() {
        let sexActionSheet = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        
        let sexNanAction = UIAlertAction(title: "从相册中选择", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            
            weakSelf?.initPhotoPicker()
            //填写需要的响应方法
            
        }
        
        let sexNvAction = UIAlertAction(title: "拍照", style: UIAlertAction.Style.default){ (action:UIAlertAction)in
            weakSelf?.initCameraPicker()
            //填写需要的响应方法
        }
        
        let sexSaceAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.cancel){ (action:UIAlertAction)in
            //填写需要的响应方法
        }
        
        sexActionSheet.addAction(sexNanAction)
        sexActionSheet.addAction(sexNvAction)
        sexActionSheet.addAction(sexSaceAction)
        
        self.present(sexActionSheet, animated: true, completion: nil)
    }
    
    // 上传图片
    func updateUserHeadImage(_ image: Data) {
        QiniuTool.sharedInstance.uploadImageData(image: image) { (progress, imageUrl) in
            if imageUrl != nil {
                GBLog("头像:\(imageUrl!)")
                self.userInfoModel.headImg = imageUrl!
            }
        }
    }
}



extension GBPersonalInfoViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 88 : 50
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        headView.backgroundColor = kSegmentateLineColor
        return  headView;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 1 && indexPath.row == 1 {
            let sexCell = tableView.dequeueReusableCell(for: indexPath, cellType: GBSexSettingCell.self)
            sexCell.cellStyle = .BaseCellStyleTextDefault
            
            let str = String(format: "%@", titles[indexPath.section][indexPath.row])
            sexCell.baseTitleLabel.text = str
            if self.userInfoModel.sex == "男" {
                sexCell.menButton.isSelected = true
            }else if self.userInfoModel.sex == "女" {
                sexCell.womenButton.isSelected = true
            }
            // 性别选择回调
            sexCell.didSelectSexBlock = {(sex) in
                self.userInfoModel.sex = sex
            }
            
            return sexCell
        }
        
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBBaseTableViewCell.self)

        let str = String(format: "%@", titles[indexPath.section][indexPath.row])
        cell.baseTitleLabel.text = str
        cell.baseDetailTextField.placeholder = "未填写"
        cell.baseLineView.isHidden = (indexPath.section == 0 || indexPath.row == 2)
        cell.baseIndicateButton.isHidden = false
        cell.cellStyle = .BaseCellStyleTextDefault

        if indexPath.section == 0 {
            // 头像
            cell.baseIndicateButton.isHidden = true
            cell.cellStyle = .BaseCellStyleImageDefault
            cell.baseImageView.kf.setImage(with:URL(string:BASE_URL_IMAGE_QINIUYUN + self.userInfoModel.headImg), placeholder:UIImage(named: self.userInfoModel.sex == "女" ? "img_women" : "img_default"))
            // 设置圆形
            GBToolConfigRadius(cell.baseLineView, radius: cell.baseLineView.width/2)
            
            headImageView = cell.baseImageView
        }
        if indexPath.section == 1  {
            if indexPath.row == 0 {
                cell.baseIndicateButton.isHidden = true
                    cell.cellStyle = .BaseCellStyleDetailInput
                    cell.baseDetailTextField.text = self.userInfoModel.nickName
                    // 昵称
                    cell.textValueChangedBlock = { (nickName) in
                        self.userInfoModel.nickName = nickName
                        self.baseTableView.reloadData()
                    }
            }else {
                // 个性签名
                cell.baseDetailTextField.text = self.userInfoModel.signature
            }
        }
        
        if indexPath.section == 2 {
            if indexPath.row == 0 {
                cell.baseDetailTextField.text = self.userInfoModel.occupation
                // 职位
                cell.textValueChangedBlock = { (occupation) in
                    self.userInfoModel.occupation = occupation
                    self.baseTableView.reloadData()
                }
            }else if indexPath.row == 1 {
                // 年龄
                cell.baseDetailTextField.text = self.userInfoModel.age
            }else {
                // 星座
                cell.baseDetailTextField.text = self.userInfoModel.constellation
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            self.changeUerHeadImage()
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            let changeInfoInputVC = GBChangeInfoInputViewController()
            changeInfoInputVC.navBar.title = "个性签名"
            changeInfoInputVC.finishBlock = { (value) in
                self.userInfoModel.signature = value
                self.baseTableView.reloadData()
            }
            navigationController?.pushViewController(changeInfoInputVC, animated: true)
        }
        
        if indexPath.section == 2 && indexPath.row != 0 {
            let vc:GBAgeConstellationTagViewController = GBAgeConstellationTagViewController()
            if  indexPath.row == 2 {
                vc.tagClassType = .TagClassTypeConstellation
                vc.navBar.title = "星座"
                vc.finishBlock = { (age) in
                    self.userInfoModel.age = age
                    self.baseTableView.reloadData()
                }
            }else {
                vc.navBar.title = "年龄段"
                vc.finishBlock = { (constellation) in
                    self.userInfoModel.constellation = constellation
                    self.baseTableView.reloadData()
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        
      
    }
}

extension GBPersonalInfoViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    //MARK: - 相机
    
    //从相册中选择
    func initPhotoPicker(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    
    //拍照
    func initCameraPicker(){
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let  cameraPicker = UIImagePickerController()
            cameraPicker.delegate = self
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = .camera
            //在需要的地方present出来
            self.present(cameraPicker, animated: true, completion: nil)
        } else {
            print("不支持拍照")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //获得照片
        let image:UIImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage

        // 拍照
        if picker.sourceType == .camera {
            //保存相册
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
        }
        
        let imageData = image.pngData()
        // 上传用户头像
        updateUserHeadImage(imageData!)
        
        headImageView.image = image
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func image(image:UIImage,didFinishSavingWithError error:NSError?,contextInfo:AnyObject) {
        
        if error != nil {
            
            print("保存失败")
            
            
        } else {
            
            print("保存成功")
            
            
        }
    }

}
