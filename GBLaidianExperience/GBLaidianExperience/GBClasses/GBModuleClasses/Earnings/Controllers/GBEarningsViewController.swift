//
//  GBEarningsViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

private let glt_iphoneX = (UIScreen.main.bounds.height == 812.0)

class GBEarningsViewController: GBBaseViewController {
    
    private let headerHeight: CGFloat = GBToolFitUI(380)
    //防止侧滑的时候透明度变化
    private var currentProgress: CGFloat = 0.0
    private let navHeight: CGFloat = UIApplication.shared.statusBarFrame.height + 44
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.navigationBar.alpha = currentProgress
        //        navigationController?.navigationBar.barTintColor = UIColor.white
        //        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18.0)]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //        navigationController?.navigationBar.barStyle = .default
        //        navigationController?.navigationBar.alpha = 1.0
    }
    
    private lazy var titles: [String] = {
        return ["创作收入", "其他收入"]
    }()
    
    private lazy var viewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for _ in titles {
            vcs.append(LTPersonalMainPageTestVC())
        }
        return vcs
    }()
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerHeight))
        return headerView
    }()
    
    private lazy var headerImageView: UIImageView = {
        let headerImageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: headerView.bounds.height))
        headerImageView.image = UIImage(named: "test")
        headerImageView.isUserInteractionEnabled = true
        headerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))
        return headerImageView
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.isAverage = true
        layout.sliderWidth = 50
        layout.bottomLineColor = kBaseColor
        layout.titleColor = kAssistTextColor
        layout.titleSelectColor = kImportantTextColor
        layout.titleViewBgColor = .white
        return layout
    }()
    
    private lazy var simpleManager: LTSimpleManager = {
        let Y: CGFloat = 0.0
        let H: CGFloat = glt_iphoneX ? (view.bounds.height - 34) : view.bounds.height
        let simpleManager = LTSimpleManager(frame: CGRect(x: 0, y: Y, width: view.bounds.width, height: H), viewControllers: viewControllers, titles: titles, currentViewController: self, layout: layout)
        
        /* 设置代理 监听滚动 */
        simpleManager.delegate = self
        
        /* 设置悬停位置 */
        simpleManager.hoverY = navHeight
        
        return simpleManager
    }()
    
    //    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        simpleManager.backgroundColor = .white
        view.addSubview(simpleManager)
        simpleManagerConfig()
        navBar.barBackgroundColor = .white
        navBar.alpha = 0
        self.view.bringSubviewToFront(navBar)
        statusBarStyle = .lightContent

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("LTSimpleManagerDemo < --> deinit")
    }
}


extension GBEarningsViewController {
    
    //MARK: 具体使用请参考以下
    private func simpleManagerConfig() {
        
        //MARK: headerView设置
        simpleManager.configHeaderView {[weak self] in
            //            guard let strongSelf = self else { return nil }
            //            strongSelf.headerView.addSubview(strongSelf.headerImageView)
            let headView = GBEarningsHeadView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: GBToolFitUI(380)))
            return headView
        }
        
        //MARK: pageView点击事件
        simpleManager.didSelectIndexHandle { (index) in
            print("点击了 \(index) 😆")
        }
        
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
}

extension GBEarningsViewController: LTSimpleScrollViewDelegate {
    
    //MARK: 滚动代理方法
    func glt_scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var headerImageViewY: CGFloat = offsetY
        var headerImageViewH: CGFloat = headerHeight - offsetY
        if offsetY <= 0.0 {
            navigationController?.navigationBar.alpha = 0
            currentProgress = 0.0
            navBar.title = ""
            navBar.alpha = currentProgress
            statusBarStyle = .lightContent

        }else {
            
            headerImageViewY = 0
            headerImageViewH = headerHeight
            
            let adjustHeight: CGFloat = headerHeight - navHeight
            let progress = 1 - (offsetY / adjustHeight)
            //设置状态栏
            statusBarStyle = progress > 0.5 ? .lightContent : .default
            
            //设置导航栏透明度
            navigationController?.navigationBar.alpha = 1 - progress
            currentProgress = 1 - progress
            navBar.title = "收益"
            navBar.alpha = currentProgress
        }
        headerImageView.frame.origin.y = headerImageViewY
        headerImageView.frame.size.height = headerImageViewH
    }
    
    //MARK: 控制器刷新事件代理方法
    func glt_refreshScrollView(_ scrollView: UIScrollView, _ index: Int) {
        //注意这里循环引用问题。
        scrollView.mj_header = MJRefreshNormalHeader {[weak scrollView] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("对应控制器的刷新自己玩吧，这里就不做处理了🙂-----\(index)")
                scrollView?.mj_header.endRefreshing()
            })
        }
    }
}

