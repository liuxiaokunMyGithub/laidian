//
//  GBMineViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

let kNavBarBottom = WRNavigationBar.navBarBottom()

private let IMAGE_HEIGHT:CGFloat = 246
private let NAVBAR_COLORCHANGE_POINT:CGFloat = IMAGE_HEIGHT - CGFloat(kNavBarBottom * 2)

private let glt_iphoneX = (UIScreen.main.bounds.height >= 812.0)

class GBMineViewController: GBBaseViewController {
    private let headerHeight: CGFloat = IMAGE_HEIGHT+121
    private let navHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44
    
    private lazy var viewControllers: [UIViewController] = {
        let oneVc = LTAdvancedTestOneVC()
        let twoVc = LTAdvancedTestOneVC()
        twoVc.count = 5
        let threeVc = LTAdvancedTestOneVC()
        let fourVc = LTAdvancedTestOneVC()
        return [oneVc, twoVc, threeVc, fourVc]
    }()
    
    private lazy var titles: [String] = {
        return ["发布", "评论", "有用", "收藏"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = true
        layout.isNeedScale = false
        layout.isHiddenSlider = true
        layout.isScrollEnabled = false
        layout.sliderHeight = 78
        layout.bottomLineColor = kBaseColor
        layout.titleFont = XKFont.pingFangSCRegular.size(16)
        layout.titleColor = kImportantTextColor
        layout.titleSelectColor = kBaseColor
        layout.titleViewBgColor = .white
        return layout
    }()
    
    lazy var tableHeadView:GBMineTableHeadView = {
        let tableHeadView = GBMineTableHeadView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: IMAGE_HEIGHT))
        return tableHeadView
    }()
    lazy var headView1:GBMineSectionHead1View = {
        let headView = GBMineSectionHead1View.init(frame: CGRect(x: 0, y: tableHeadView.bottom, width: kScreenWidth, height: 121))
        return headView
    }()
    lazy var headView2:GBMineSectionHeadView = {
        let headView = GBMineSectionHeadView.init(frame: CGRect(x: 0, y: headView1.bottom, width: kScreenWidth, height: 75))
        return headView
    }()
    
    private func managerReact() -> CGRect {
        let Y: CGFloat = 0
        let H: CGFloat = kScreenHeight - kTabBarHeight
        return CGRect(x: 0, y: Y, width: view.bounds.width, height: H)
    }
    
    private lazy var advancedManager: LTAdvancedManager = {
        let advancedManager = LTAdvancedManager(frame: managerReact(), viewControllers: viewControllers, titles: titles,titleStrs:[GBToolChangePartOfStringStyle(allString: "发布\n2345", rangeString: "2345", color: kAssistTextColor, font: XKFont.pingFangSCRegular.size(12)!),GBToolChangePartOfStringStyle(allString: "评论\n2345", rangeString: "2345", color: kAssistTextColor, font: XKFont.pingFangSCRegular.size(12)!),GBToolChangePartOfStringStyle(allString: "有用\n2345", rangeString: "2345", color: kAssistTextColor, font: XKFont.pingFangSCRegular.size(12)!),GBToolChangePartOfStringStyle(allString: "收藏\n2345", rangeString: "2345", color: kAssistTextColor, font: XKFont.pingFangSCRegular.size(12)!)], currentViewController: self, layout: layout, headerViewHandle: {[weak self] in
            guard let strongSelf = self else { return UIView() }
            let headerView = strongSelf.headBGView()
            return headerView
        })
        
        
        /* 设置代理 监听滚动 */
        advancedManager.delegate = self
        
        /* 设置悬停位置 */
        advancedManager.hoverY = kStatusNavigationHeight
        
        /* 点击切换滚动过程动画 */
        //        advancedManager.isClickScrollAnimation = true
        
        /* 代码设置滚动到第几个位置 */
        //        advancedManager.scrollToIndex(index: viewControllers.count - 1)
        return advancedManager
    }()
    
    
    var userModel = GBUserModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        self.getUserInfo()
        
        setupPageMenu()
        
        setupNaviBar()

        // 状态栏
        statusBarStyle = .lightContent
    }
    
    func setupPageMenu() {
        advancedManager.backgroundColor = kBackgroundColor
        view.addSubview(advancedManager)
        
        let cellAcrossPartingLine = UIView.init(frame: CGRect(x: 0, y: 70, width: kScreenWidth, height: 8))
        cellAcrossPartingLine.backgroundColor = kSegmentateLineColor;
        advancedManager.titleView.addSubview(cellAcrossPartingLine)
        advancedManagerConfig()
    }
    
    func setupNaviBar() {
        self.view.bringSubviewToFront(navBar)
        navBar.barBackgroundColor = kBaseColor.withAlphaComponent(0)
        navBar.wr_setBottomLineHidden(hidden: true)
        navBar.titleLabelColor = .white
        navBar.wr_setLeftButton(image: UIImage(named: "icon_setting")!)
        navBar.wr_setRightButton(image: UIImage(named: "icon_share")!)
        navBar.onClickLeftButton = {
            let settingVC = GBSettingViewController.init()
            self.navigationController?.pushViewController(settingVC, animated: true)
        }
        navBar.onClickRightButton = {
            self.showShareView()
        }
    }
    
    // 分享
    func showShareView() {
        let buttonInfo = ["icon_wechat":"微信好友","icon_friends":"朋友圈"]
        let shareView = XKShareCustomView(frame:view.bounds ,buttonInfo: buttonInfo)
        shareView.delegate = self
        shareView.show()
    }
    
    deinit {
        print("LTAdvancedManagerDemo < --> deinit")
    }
    
}

// 网络请求
extension GBMineViewController {
    // 用户信息
    func getUserInfo() {
        NetworkTool.shared.post(UrlPath.MineUserInfo.rawValue, parameters: ["id" : GBUserDefaults.string(forKey: UDK_UserId) as Any], methodLog: "用户信息") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                self.userModel = JsonTool.dictionaryToModel(result!["data"].rawValue as! [String : Any], GBUserModel.self) as! GBUserModel
            }
        }
    }
    
    
}

extension GBMineViewController: LTAdvancedScrollViewDelegate {
    
    //MARK: 具体使用请参考以下
    private func advancedManagerConfig() {
        //MARK: 选中事件
        advancedManager.advancedDidSelectIndexHandle = {
            print("选中了 -> \($0)")
        }
        
    }
    
    //MARK: 滚动代理方法
    func glt_scrollViewOffsetY(_ offsetY: CGFloat) {
        var headerImageViewY: CGFloat = offsetY
        var headerImageViewH: CGFloat = headerHeight - offsetY
        if offsetY <= 0.0 {
            navBar.title = ""
            navBar.barBackgroundColor = UIColor.white.withAlphaComponent(0)
        }else {
            
            headerImageViewY = 0
            headerImageViewH = headerHeight
            
            let adjustHeight: CGFloat = headerHeight - navHeight
            let progress = 1 - (offsetY / adjustHeight)
            //设置导航栏透明度
            navBar.title = "我的"
            navBar.barBackgroundColor = kBaseColor.withAlphaComponent(1-progress)
        }
    }
}

extension GBMineViewController:XKShareCustomViewProtocol {
    // 分享代理
    func didClickOnItemAtIndex(index: Int) {
        GBLog("分享index = \(index)")
    }
    
    private func headBGView() -> UIImageView {
        let headBGView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: IMAGE_HEIGHT+121))
        headBGView.addSubview(tableHeadView)
        headBGView.addSubview(headView1)
        return  headBGView
    }
    
    
    func updateHeadView() {
        tableHeadView.iconView.kf.setImage(with:URL(string:BASE_URL_IMAGE_QINIUYUN + self.userModel.headImg), placeholder:UIImage(named: self.userModel.sex == "女" ? "img_women" : "img_default"))
        tableHeadView.nameLabel.text = self.userModel.nickName
    }
}

