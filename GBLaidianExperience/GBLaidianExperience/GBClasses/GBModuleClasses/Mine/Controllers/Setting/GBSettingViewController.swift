//
//  GBSettingViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/31.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBSettingViewController: GBBaseViewController {
    lazy var titles:[[String]] = [["个人资料","常见问题","意见反馈"],["关于我们","联系客服"],["当前版本号"]]
    lazy var loginOutButton:UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.frame = CGRect.init(x:0, y: 32, width: kScreenWidth, height: 50)
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(kRedTextColor, for: .normal)
        btn.backgroundColor = .white
        btn.addTarget(self, action: #selector(loginOutAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var footView:UIView = {
       let footView = UIView()
        footView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 88)
        footView.backgroundColor = .clear
        return footView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = "设置"
        setupUI()
    }
    
    deinit {
        
    }
}

extension GBSettingViewController {
    func setupUI() {
        baseTableView.delegate = self
        baseTableView.dataSource = self
        baseTableView.rowHeight = 50
        baseTableView.sectionHeaderHeight = 8
        baseTableView.sectionFooterHeight = 0.000001
        baseTableView.mj_header = nil
        baseTableView.mj_footer = nil
//        baseTableView.register(GBBaseTableViewCell.self, forCellReuseIdentifier: "GBBaseTableViewCell")
        view.addSubview(baseTableView)
        view.backgroundColor = UIColor.ColorFromHexStr(hexString: "#F5F5F5")
        baseTableView.backgroundColor = view.backgroundColor
        
        footView.addSubview(loginOutButton)
        baseTableView.tableFooterView = footView
    }
    
    @objc func loginOutAction() {
        GBLog("退出登录")
    }
}



extension GBSettingViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 3 : section == 1 ? 2 : 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = UIView.init()
        headView.backgroundColor = kSegmentateLineColor
        return  headView;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
//        let cell = GBBaseTableViewCell.creatCell(tableView: tableView, indexPath: indexPath)
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBBaseTableViewCell.self)
        cell.cellStyle = .BaseCellStyleTextDefault
        let str = String(format: "%@", titles[indexPath.section][indexPath.row])
        cell.baseTitleLabel.text = str
        cell.baseLineView.isHidden = indexPath.row == titles[indexPath.section].count-1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc:GBPersonalInfoViewController = GBPersonalInfoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
