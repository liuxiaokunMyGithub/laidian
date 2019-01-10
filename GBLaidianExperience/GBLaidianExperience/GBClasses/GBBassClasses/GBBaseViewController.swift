//
//  GBBaseViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/30.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit
import MJRefresh

// 数据加载类型枚举
enum LoadingDataStyle: Int {
    // 下拉刷新
    case LoadingDataRefresh = 0
    // 上拉加载
    case LoadingDataGetMore = 1
}

class GBBaseViewController: UIViewController {
    // 数据加载方式
    var loadingStyle: LoadingDataStyle = .LoadingDataRefresh
    // 页码
    var page:Int = 1
    // 自定义导航栏
    lazy var navBar = WRCustomNavigationBar.CustomNavigationBar()
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.baseTableView.contentInsetAdjustmentBehavior = .never;
        }else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        setupNavBar()
        
    }
    
    // 设置导航栏
    func setupNavBar() {
        self.view.addSubview(navBar)
        // 设置自定义导航栏背景颜色
        if self.navigationController?.children.count != 1 {
            navBar.wr_setLeftButton(image: UIImage(named: "icon_return_blue")!)
            navBar.onClickLeftButton = {
                self.back()
            }
        }
    }
    
    func setupCustomNavBarRightButton(rightTitle:String) {
        navBar.wr_setRightButton(title: rightTitle, titleColor: kBaseColor)
        
        let width = rightTitle.textSizeCalculate(font: XKFont.pingFangSCRegular.size(18)!, width: kScreenWidth).width
        
        navBar.rightButton.snp.makeConstraints { (make) in
            make.right.equalTo(navBar).offset(-12)
            make.width.equalTo((width));
            make.height.equalTo(44);
            make.top.equalTo((kStatusBarHeight));
        }
    }
    
    func setupCustomNavBarLeftButton(leftImageName:String, leftTitle:String) {
        navBar.wr_setLeftButton(normal: UIImage(named: leftImageName), highlighted:nil, title:leftTitle, titleColor:kBaseColor)
        
        let width = leftTitle.textSizeCalculate(font: XKFont.pingFangSCRegular.size(18)!, width: kScreenWidth).width + (leftImageName.length > 0 ? 30 : 0)
        
        navBar.leftButton.snp.makeConstraints { (make) in
            make.left.equalTo(navBar).offset(12)
            make.width.equalTo((width));
            make.height.equalTo(44);
            make.top.equalTo((kStatusBarHeight));
        }
    }
    
    lazy var baseTableView:UITableView = {
        let tableView:UITableView = UITableView(frame: CGRect.init(x: 0, y: CGFloat(kNavBarBottom), width: kScreenWidth, height: kScreenHeight - ((self.navigationController?.children.count == 1) ? (kTabBarHeight+kStatusNavigationHeight) : kBottomSafeAreaHeight+kStatusNavigationHeight)), style: .plain)
        tableView.backgroundColor = .white
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.separatorStyle = .none
        tableView.register(GBBaseTableViewCell.self, forCellReuseIdentifier: "GBBaseTableViewCell")
        // 刷新头部
        let header = MJRefreshHeader { [weak self] in
            self!.headerRereshing()
        }
        header?.isAutomaticallyChangeAlpha = true
        tableView.mj_header = header
        // 底部刷新控件
        tableView.mj_footer = MJRefreshAutoGifFooter(refreshingBlock: { [weak self] in
            self!.footerLoadMore()
        })
        tableView.mj_footer.isAutomaticallyChangeAlpha = true
        
        return tableView
    }()
    
    func headerRereshing() {
        GBLog("下拉刷新")
        // 重置没有更多数据状态
        self.baseTableView.mj_footer.resetNoMoreData();
        self.loadingStyle = .LoadingDataRefresh
        self.page = 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 35) {
            self.baseTableView.mj_header.endRefreshing();
        }
    }
    
    func footerLoadMore() {
        GBLog("上拉加载")
        self.loadingStyle = .LoadingDataGetMore
        self.page += 1
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 35) {
            self.baseTableView.mj_footer.endRefreshing();
        }
    }
    
    @objc fileprivate func back() {
        _ = navigationController?.popViewController(animated: true)
    }
}
