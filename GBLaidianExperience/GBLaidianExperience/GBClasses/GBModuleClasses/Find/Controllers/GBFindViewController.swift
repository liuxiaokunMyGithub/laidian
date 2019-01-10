//
//  GBFindViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBFindViewController: GBBaseViewController {
    var giftModels = [GBGiftModel]()
    fileprivate var categoryList = [GBEssayCategoryModel]()

    lazy var tableViewHead: UIView = {
        let head = UIView()
        head.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: GBToolFitUI(210))
        head.backgroundColor = .white
        return head
    }()
    lazy var cycleScrollView:WRCycleScrollView = {
        let frame = CGRect(x: GBMargin, y: GBMargin, width: CGFloat(kScreenWidth) - GBMargin*2, height: GBToolFitUI(194))
        let cycleView = WRCycleScrollView(frame: frame, type: .LOCAL, imgs: nil, descs: nil)
        cycleView.currentDotColor = .white
        cycleView.otherDotColor = UIColor.white.withAlphaComponent(0.5)
        return cycleView
    }()
    
    let localImages = ["banner01","banner01","banner01","banner01","banner01"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.title = "分类"
        navBar.wr_setLeftButton(image: UIImage(named: "icon_location")!)
        navBar.onClickLeftButton = {
           let citySelectorVC = CitySelectorViewController()
            citySelectorVC.updateCityName = {(_ str:String) in
                self.setupCustomNavBarLeftButton(leftImageName:"icon_location", leftTitle:str)
            }
            self.navigationController?.pushViewController(citySelectorVC, animated: true)
        }
        
        self.getBannerRequest()
        self.getEssayCategory()
        self.getGiftListRequest()
        
        setupUI()
        
        self.view.backgroundColor = .white
        
    }
    
    func setupUI() {
        baseTableView.dataSource = self
        baseTableView.delegate = self
        baseTableView.mj_header = nil
        baseTableView.mj_footer = nil
        baseTableView.backgroundColor = .white
        baseTableView.sectionFooterHeight = 0.000001
        baseTableView.register(cellType: GBClassificationTableViewCell.self)
        baseTableView.register(headerFooterViewType: GBBaseTableViewHeaderFooterView.self)
        view.addSubview(baseTableView)
        baseTableView.register(cellType: GBGiftTableViewCell.self)
        cycleScrollView.localImgArray = localImages
        tableViewHead.addSubview(cycleScrollView)
        baseTableView.tableHeaderView = tableViewHead
        GBToolConfigRadius(cycleScrollView,radius: 4)
    }
    
    
}

// 网络相关
extension GBFindViewController {
    func getBannerRequest() {
        NetworkTool.shared.post(UrlPath.FindDdvertisement.rawValue, parameters: nil, methodLog: "广告Banner") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                
            }
        }
    }
    
    func getGiftListRequest() {
        NetworkTool.shared.post(UrlPath.FindGiftList.rawValue, parameters:["pageNo":page,"pageSize":4], methodLog: "礼物列表") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                self.giftModels = JsonTool.dictionaryArrayToModelArray((result?["data"].rawValue as! Array), GBGiftModel.self) as! [GBGiftModel]
                
                self.baseTableView.reloadData()
            }
        }
    }
    
    // 分类
    func getEssayCategory() {
        NetworkTool.shared.post(UrlPath.EssayCategory.rawValue, parameters: nil, methodLog: "fe") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                self.categoryList = JsonTool.dictionaryArrayToModelArray((result?["data"].rawValue as! Array), GBEssayCategoryModel.self) as! [GBEssayCategoryModel]
                self.baseTableView.reloadData()
            }
        }
    }
    
}
extension GBFindViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : giftModels.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? GBToolFitUI(54) : GBToolFitUI(42)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? GBToolFitUI(CGFloat(87 * self.categoryList.count/2)) : GBToolFitUI(155)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let head = tableView.dequeueReusableHeaderFooterView(GBBaseTableViewHeaderFooterView.self)
        head!.headerFooterStyle = .BaseHeaderFooterStyleTextDefault
        head?.baseTitleLabel.text = section == 0 ? "经验分类" : "商品专区"
        return head
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBClassificationTableViewCell.self)
            cell.categoryList = self.categoryList
            return cell
        }
        
       let giftCell = tableView.dequeueReusableCell(for: indexPath, cellType: GBGiftTableViewCell.self)
        giftCell.giftModel = self.giftModels[indexPath.row]
        return giftCell
    }
}

