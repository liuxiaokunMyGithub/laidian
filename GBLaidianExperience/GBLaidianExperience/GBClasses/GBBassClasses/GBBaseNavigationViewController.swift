//
//  GBBaseNavigationViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBBaseNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension GBBaseNavigationViewController
{
    override func pushViewController(_ viewController: UIViewController, animated: Bool)
    {
        if children.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
