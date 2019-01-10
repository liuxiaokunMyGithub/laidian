//  GBRecommendedViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import Foundation

class GBRecommendedViewController: UIViewController, LTTableViewProtocal {
    
    private lazy var tableView: UITableView = {
        let H: CGFloat = kScreenHeight - kStatusBarHeight - kTabBarHeight
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), self, self, nil)
        tableView.register(cellType: WeitoutiaoCell.self)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        return tableView
    }()
    
    /// 新闻数据
    var news = [NewsModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // 获取新闻列表数据
        self.getHomeEssayList()
        
        view.addSubview(tableView)
        glt_scrollView = tableView
        reftreshData()
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}

extension GBRecommendedViewController {
    
    fileprivate func reftreshData()  {
        tableView.mj_header = MJRefreshNormalHeader {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("下拉刷新 --- 1")
                self?.getHomeEssayList()
                self?.tableView.mj_header.endRefreshing()
            })
        }
        
        tableView.mj_footer = MJRefreshBackNormalFooter {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                print("上拉加载更多数据")
                self?.tableView.mj_footer.endRefreshing()
            })
        }
    }
    
    func getHomeEssayList() {
        let paramter = [
            "pageNo":1,
            "pageSize":10,
            "queryTab":"n",
            ] as [String : Any]
        NetworkTool.shared.post(UrlPath.HomeEssayList.rawValue, parameters: paramter, methodLog: "首页推荐") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                self.news = JsonTool.dictionaryArrayToModelArray((result?["data"].rawValue as! Array), NewsModel.self) as! [NewsModel]
                
                self.tableView.reloadData()
            }
        }
    }
}


extension GBRecommendedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.zz_heightForCellWithIdentifier(identifier: WeitoutiaoCell.reuseIdentifier, cacheByIndexPath: indexPath as NSIndexPath, configuration: { (cell) -> () in
            guard let cell = cell as? WeitoutiaoCell else { return }
            cell.aNews = self.news[indexPath.row]
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: WeitoutiaoCell.self)
        cell.aNews = news[indexPath.row]
        cell.selectionStyle = .none
        // 点击了哪张图片
        cell.didSelectCell = { [weak self] (selectedIndex) in
            let previewBigImageVC = PreviewDongtaiBigImageController()
            previewBigImageVC.images = cell.aNews.images
            previewBigImageVC.selectedIndex = selectedIndex
            self!.present(previewBigImageVC, animated: false, completion: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = GBExperienceDetailsViewController()
        detailVC.newsModel = self.news[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}
