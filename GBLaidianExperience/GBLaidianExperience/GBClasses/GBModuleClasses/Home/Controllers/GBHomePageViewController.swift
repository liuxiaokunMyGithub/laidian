//
//  GBHomePageViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/1.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBHomePageViewController: GBBaseViewController {
    
    private lazy var viewControllers: [UIViewController] = {
        let oneVc = GBRecommendedViewController()
        let twoVc = GBHotViewController()
        return [oneVc, twoVc]
    }()
    
    private lazy var titles: [String] = {
        return ["热门", "推荐"]
    }()
    
    private lazy var layout: LTLayout = {
        let layout = LTLayout()
        layout.sliderWidth = 50
        layout.titleMargin = 20
        layout.bottomLineColor = kBaseColor
        layout.titleColor = kAssistTextColor
        layout.titleSelectColor = kImportantTextColor
        layout.showsHorizontalScrollIndicator = false
        // （屏幕宽度 - 标题总宽度 - 标题间距宽度） / 2 = 最左边以及最右边剩余
        let lrMargin = (view.bounds.width - (CGFloat(titles.count) * layout.sliderWidth + CGFloat(titles.count - 1) * layout.titleMargin)) * 0.5
        layout.lrMargin = lrMargin
        layout.isAverage = true
        return layout
    }()
    
    private lazy var pageView: LTPageView = {
        let statusBarH = UIApplication.shared.statusBarFrame.size.height
        let Y: CGFloat = statusBarH + 44
        let H: CGFloat = isIPhoneX ? (view.bounds.height - Y - 34) : view.bounds.height - Y
        let pageView = LTPageView(frame: CGRect(x: 0, y: kStatusBarHeight, width: view.bounds.width, height: H), currentViewController: self, viewControllers: viewControllers, titles: titles, layout: layout)
        pageView.isClickScrollAnimation = true
        return pageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // automaticallyAdjustsScrollViewInsets = false
        view.addSubview(pageView)
        view.sendSubviewToBack(pageView)
        pageView.pageTitleView.backgroundColor = .white
        pageView.pageTitleView.top = kStatusBarHeight
        navBar.insertSubview(pageView.pageTitleView, at: 1)
        navBar.wr_setRightButton(title: "+发布", titleColor: kBaseColor)
        navBar.onClickRightButton = {
            GBLog("发布")
            let searchVC = GBPostExperienceViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        navBar.wr_setLeftButton(image: UIImage(named:"icon_search" )!)
        navBar.onClickLeftButton = {
            GBLog("搜索")
            let searchVC = USearchViewController()
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
        
        navigationItem.title = ""
        let leftButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        leftButton.setImage(UIImage(named:"icon_search" ), for: .normal)
        leftButton.addTarget(self, action: #selector(leftBarSettingButtonItemClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+发布", style: .plain, target: self, action: #selector(rightBarShareButtonItemClicked))
        
        pageView.didSelectIndexBlock = {(_, index) in
            print("pageView.didSelectIndexBlock", index)
        }
    }
    
    @objc func leftBarSettingButtonItemClicked() {
        let searchVC = USearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    @objc func rightBarShareButtonItemClicked() {
        let searchVC = GBPostExperienceViewController()
        navigationController?.pushViewController(searchVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
