//  GBHotViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/10/29.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import Foundation

class GBHotViewController: UIViewController, LTTableViewProtocal {
    lazy var marquee: SSTextMarquee = {
        let marquee = createMarquee()
        marquee.direction = .verticalDown
        return marquee
    }()
    
    lazy var headView: UIView = {
        let headView = UIView()
        headView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: GBToolFitUI(28))
        let newsIcon = UIImageView.init(frame: CGRect(x: GBMargin, y: GBToolFitUI(6), width: 20, height: 17))
        newsIcon.image = UIImage(named: "icon_news")
        headView.addSubview(newsIcon)
        headView.backgroundColor = UIColor.ColorFromHexStr(hexString: "#83C1E6")
        return headView
    }()
    
    private lazy var tableView: UITableView = {
        let H: CGFloat = kScreenHeight - kStatusBarHeight - kTabBarHeight
        let tableView = tableViewConfig(CGRect(x: 0, y: 0, width: view.bounds.width, height: H), self, self, nil)
        tableView.register(cellType: WeitoutiaoCell.self)
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
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
        marquee.frame = CGRect(x: 40, y: 0, width: kScreenWidth-40-GBMargin, height: GBToolFitUI(28))
        headView.addSubview(marquee)
        tableView.tableHeaderView = headView
        
        marquee.startAnimation()
        
    }
    
    func createMarquee() -> SSTextMarquee {
        let marquee = SSTextMarquee()
        marquee.delegate = self
        marquee.titles = ["1.两只黄鹂鸣翠柳  已发布24条经验，总收入6982元。",
                          "2.一行白鹭上青天  已发布24条经验，总收入6982元。.",
                          "3.飞流直下三千尺 已发布24条经验，总收入6982元。."]
        marquee.textColor = .white
        
        marquee.interval = 3
        marquee.animateDuration = 0.5
        marquee.font = XKFont.pingFangSCRegular.size(12)!
        marquee.numberOfLines = 2
        marquee.padding = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        marquee.backgroundColor = .clear
        marquee.delegate = self
        return marquee
    }

    deinit {
        marquee.delegate = nil
        marquee.stopTimer()
    }
}

extension GBHotViewController {
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


extension GBHotViewController:SSTextMarqueeDelegate, UITableViewDelegate, UITableViewDataSource {
    // MARK: 跑马灯代理
    func textMarqueeDidTapTitle(_ marquee: SSTextMarquee, _ title: String, _ index: Int) {
        print(title)
    }
    
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
        
        // 点击了那张图片
        cell.didSelectCell = { [weak self] (selectedIndex) in
            let previewBigImageVC = PreviewDongtaiBigImageController()
            previewBigImageVC.images = cell.aNews.images
            previewBigImageVC.selectedIndex = selectedIndex
            self!.present(previewBigImageVC, animated: false, completion: nil)
        }
        cell.contentLabel.numberOfLines = 3;
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = GBExperienceDetailsViewController()
        detailVC.newsModel = self.news[indexPath.row]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}

