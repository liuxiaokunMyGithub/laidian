//
//  GBPostExperienceViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/6.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBPostExperienceViewController: GBBaseViewController {
    fileprivate var tagList = [GBEssayCategoryModel]()
    
    var mianScrollView = UIScrollView()
    var height:CGFloat = (kScreenWidth - 20)/3
    // 选择的标签
    var selectTags = NSMutableArray()
    var selectImages = NSMutableArray()
    var imageUrls = NSMutableArray()
    // 是否在上传图片
    var isUploadingImage = false
    
    var relatedCity:String = ""
    
    lazy var titleTextView: NextGrowingTextView = {
        let textView = NextGrowingTextView()
        textView.maxNumberOfLines = 2
        
        textView.placeholderAttributedText = NSAttributedString(
            string: "请输入经验的标题",
            attributes: [
                .font: XKFont.pingFangSCRegular.size(16) as Any,
                .foregroundColor: kAssistTextColor
            ])
        
        return textView
    }()
    
    lazy var lineView:UIView = {
        let line = UIView()
        line.backgroundColor = kLineColor
        return line
    }()
    
    lazy var detailsTextView: NextGrowingTextView = {
        let textView = NextGrowingTextView()
        textView.maxNumberOfLines = 10
        textView.placeholderAttributedText = NSAttributedString(
            string: "添加经验详情，让看到的人更透彻的学习到这条经验。",
            attributes: [
                .font: XKFont.pingFangSCRegular.size(14) as Any,
                .foregroundColor: kAssistTextColor
            ])
        return textView
    }()
    
    lazy var titleLengthButton:GBLIRLButton = {
        let button = GBLIRLButton()
        button.setTitleColor(kAssistTextColor, for: .normal)
        button.setTitle("0/30", for: .normal)
        button.titleLabel!.font = XKFont.pingFangSCRegular.size(12)
        return button
    }()
    
    lazy var detailLengthLabel:UILabel = {
        let detail = UILabel()
        detail.textColor = kAssistTextColor
        detail.font = XKFont.pingFangSCRegular.size(12)
        detail.text = "0/300"
        return detail
    }()
    
    //创建方式4 带配置（单例配置对象）
    lazy var picker: TGPhotoPicker = TGPhotoPicker(self, frame: CGRect(x: 10, y: 0, width: kScreenWidth-20, height: self.view.bounds.size.width/3)) { _ in
        TGPhotoPickerConfig.shared.tg_type(.weibo)
            .tg_checkboxLineW(1)
            .tg_colCount(4)
            .tg_toolBarH(50)
            .tg_useChineseAlbumName(true)
        TGPhotoPickerConfig.shared.padding = 5
        TGPhotoPickerConfig.shared.mainColCount = 3
        TGPhotoPickerConfig.shared.leftAndRigthNoPadding = false
        TGPhotoPickerConfig.shared.autoSelectWH = true
    }
    
    lazy var tagTitleLabel:UILabel = {
        let label = UILabel()
        label.textColor = kAssistTextColor
        label.font = XKFont.pingFangSCRegular.size(14)
        label.text = "请选择分类，1-2项"
        return label
    }()
    
    var tagView = ACTagView(frame: CGRect(x: 0, y: kStatusNavigationHeight, width:kScreenWidth, height: GBToolFitUI(80)), layoutType: .autoLineFeed)
    // 发布
    lazy var sendButton:UIButton = {
        let sendButton = UIButton()
        sendButton.setImage(UIImage(named: "button_Release"), for: .normal);
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        return sendButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = "发布经验"
        navBar.wr_setRightButton(title: "帮助", titleColor: kBaseColor)
        navBar.onClickRightButton = {
            GBLog("帮助")
        }
        
        getEssayCategory()
        
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(mianScrollView)
        view.sendSubviewToBack(mianScrollView)
        
        // 完成图片选择
        picker.onClickFinishButton = { (images) in
            var dataArray = [Data]()
            for model in images {
                if !self.selectImages.contains(model.imageData!) {
                    dataArray.append(model.imageData!)
                }
            }
            
            if dataArray.count > 0 {
                self.selectImages.addObjects(from: dataArray)
                
                // 上传当前新添加的图片
                self.updateSelectImages(dataArray)
            }
            
            
            let result = self.picker.tgphotos.count / 3
            self.height = result >= 2 ? (kScreenWidth-20)/3*3 : result >= 1 ? (kScreenWidth-20)/3*2 :  (kScreenWidth-20)/3
            
            self.addSnp()
            
            self.picker.collectionView!.height = self.height
        }
        
        
        mianScrollView.addSubview(picker)
        
        mianScrollView.addSubview(titleTextView)
        mianScrollView.addSubview(lineView)
        mianScrollView.addSubview(detailsTextView)
        mianScrollView.addSubview(titleLengthButton)
        mianScrollView.addSubview(detailLengthLabel)
        mianScrollView.addSubview(tagTitleLabel)
        mianScrollView.addSubview(sendButton)
        
        self.titleTextView.textView.maxCharLength = 30
        self.detailsTextView.textView.maxCharLength = 300
        
        NotificationCenter.default.addObserver(self, selector:#selector(textViewLengthNoti(noti:)) , name: NSNotification.Name(rawValue: UITextViewTextLengthDidChangeNotification), object: nil)
        
        ACTagConfig.default.tagBorderType = .custom(radius: 2)
        ACTagConfig.default.selectedTagTextColor = kBaseColor
        ACTagConfig.default.tagTextColor = kAssistTextColor
        ACTagConfig.default.tagBorderColor = kLineColor
        ACTagConfig.default.selectedTagBorderColor = kBaseColor
        ACTagConfig.default.tagBorderWidth = 0.5
        
        tagView.allowsMultipleSelection = true
        //      tagView.isScrollEnabled = false
        tagView.selectMaxCount = 2
        tagView.tagHeight = GBMargin*2
        tagView.margin = ACTagDistance(horizontal: GBMargin,vertical: GBMargin)
        tagView.tagMargin = ACTagDistance(horizontal: 6,vertical: 6)
        tagView.tagDataSource = self
        tagView.tagDelegate = self
        tagView.backgroundColor = UIColor.white
        tagView.tag = 0
        mianScrollView.addSubview(tagView)
        
        addSnp()
        
        mianScrollView.contentSize =  CGSize(width: 0, height: kScreenHeight+100);
    }
    
    func addSnp() {
        mianScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleTextView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(kStatusNavigationHeight + 8)
            make.left.equalTo(self.view).offset(GBMargin)
            make.right.equalTo(titleLengthButton.snp.left).offset(-1)
        }
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextView.snp.bottom).offset(5)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.height.equalTo(1)
        }
        
        detailsTextView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(5)
            make.left.equalTo(self.view).offset(GBMargin)
            make.right.equalTo(self.view).offset(-GBMargin)
            
        }
        
        titleLengthButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(kStatusNavigationHeight + 8)
            make.right.equalTo(self.view).offset(0)
            make.width.lessThanOrEqualTo(65)
            make.centerY.equalTo(titleTextView)
        }
        detailLengthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(detailsTextView.snp.bottom).offset(8)
            make.right.equalTo(self.view).offset(-GBMargin)
        }
        
        picker.snp.updateConstraints { (make) in
            make.top.equalTo(detailLengthLabel.snp.bottom).offset(8)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.lessThanOrEqualTo(height)
        }
        
        tagTitleLabel.snp.updateConstraints { (make) in
            make.top.equalTo(picker.snp.bottom).offset(GBMargin)
            make.left.equalTo(self.view).offset(GBMargin)
            make.right.equalTo(self.view).offset(-GBMargin)
        }
        
        tagView.snp.makeConstraints { (make) in
            make.top.equalTo(tagTitleLabel.snp.bottom).offset(0)
            make.left.equalTo(self.view).offset(0)
            make.right.equalTo(self.view).offset(-GBMargin)
            make.height.equalTo(100)
        }
        sendButton.snp.makeConstraints { (make) in
            make.top.equalTo(tagView.snp.bottom).offset(GBMargin*2)
            make.left.equalTo(self.view).offset(GBMargin)
            make.right.equalTo(self.view).offset(-GBMargin)
            make.height.equalTo(44)
        }
    }
    
    @objc func textViewLengthNoti(noti:NSNotification) {
        //可通过textView对象判断当前的textView是哪一个
        let textView  = noti.object as! UITextView
        if textView === self.titleTextView.textView {
            titleLengthButton.setTitle("\(textView.text!.length)/30", for: .normal)
            titleLengthButton.setImage(UIImage(named: textView.text!.length > 0 ? "icon_delete_circle" : ""), for: .normal)
        }else if textView === self.detailsTextView.textView {
            detailLengthLabel.text = "\(textView.text!.length)/300"
        }
    }
    
    // 发布文章
    @objc func sendButtonAction() {
        if titleTextView.textView.text.length < 4 {
            return GBToolShowMessage("请输入不少于4字标题")
        }
        
        if detailsTextView.textView.text.length < 50 {
            return GBToolShowMessage("请输入不少于50字经验详情")
        }
        
        if selectTags.count < 1 {
            return GBToolShowMessage("请至少选择一项分类标签")
        }
        
        // 是否正在上传图片
        if isUploadingImage {
            return GBToolShowMessage("图片上传中，请稍后")
        }
        
        let param = NSMutableDictionary.init(dictionary: ["title":titleTextView.textView.text,"content":detailsTextView.textView.text])
        
        if imageUrls.count > 0 {
            param.addEntries(from: ["images" : imageUrls])
        }
        
        if selectTags.count > 0 {
            param.addEntries(from: ["category" : selectTags])
        }
        
        if relatedCity != "" {
            param.addEntries(from: ["relatedCity" : relatedCity])
        }
        
        NetworkTool.shared.post(UrlPath.HomePublishEssay.rawValue, parameters: param as? [String : Any], methodLog: "发布文章") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                GBToolShowMessage(message!)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: UITextViewTextLengthDidChangeNotification), object: nil)
        
    }
}

// MARK: 网络请求相关
extension GBPostExperienceViewController {
    // 文章分类
    func getEssayCategory() {
        NetworkTool.shared.post(UrlPath.EssayCategory.rawValue, parameters: nil, methodLog: "fe") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                self.tagList = JsonTool.dictionaryArrayToModelArray((result?["data"].rawValue as! Array), GBEssayCategoryModel.self) as! [GBEssayCategoryModel]
                self.tagView.reloadData()
            }
        }
    }
    
    // 上传图片
    func updateSelectImages(_ images: [Data]) {
        self.isUploadingImage = true
        QiniuTool.sharedInstance.upImageDatas(images: images, result: { (Float, imageUrl) in
            GBLog("图片上传imageUrl:\(imageUrl!)")
            if imageUrl != nil {
                self.imageUrls.add(imageUrl as Any)
            }
        }) {
            GBLog("图片上传结束")
            self.isUploadingImage = false
        }
    }
}

extension GBPostExperienceViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension GBPostExperienceViewController: ACTagViewDataSource {
    func numberOfTags(in tagView: ACTagView) -> Int {
        return tagList.count
    }
    
    func tagView(_ tagView: ACTagView, tagAttributeForIndexAt index: Int) -> ACTagAttribute {
        let tag = ACTagAttribute(text: tagList[index].name!)
        return tag
    }
}

extension GBPostExperienceViewController: ACTagViewDelegate {
    
    func tagView(_ tagView: ACTagView, didSelectTagAt index: Int) {
        self.selectTags.add(tagList[index].id)
        GBLog("selectTags : \(selectTags)")
        
    }
    
    func tagView(_ tagView: ACTagView, didDeselectTagAt index: Int) {
        self.selectTags.remove(tagList[index].id)
        
        GBLog("selectTags : \(selectTags)")
        
    }
    
}
