//
//  GBMainTabBarControllerViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBMainTabBarControllerViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 修改标签栏选中时文字颜色、字体
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kBaseColor], for: .selected)
        
        // 修改标签栏未选中时文字颜色、字体
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kImportantTextColor], for: .normal)
        // 添加子控制作器
        addChildViewControllers()
    }
    
    // 添加子控制器
    private func addChildViewControllers() {
        setChildViewController(GBHomePageViewController(), title: "首页", imageName: "icon_home", imageNameHighlighted:"icon_home_press")
        setChildViewController(GBFindViewController(), title: "发现", imageName: "icon_found", imageNameHighlighted:"icon_found_press")
        setChildViewController(GBEarningsViewController(), title: "收益", imageName:"icon_earnings", imageNameHighlighted:"icon_earnings_press")
        setChildViewController(GBMineViewController(), title: "我的", imageName: "icon_mine", imageNameHighlighted:"icon_mine_press")
    }
    
    /// 初始化子控制器
    private func setChildViewController(_ childController: UIViewController, title: String, imageName: String , imageNameHighlighted: String) {
        // 设置 tabbar 文字和图片
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: imageNameHighlighted)?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        childController.title = title
        // 添加导航控制器为 TabBarController 的子控制器
        addChild(GBBaseNavigationViewController(rootViewController: childController))
    }
    
}
