//
//  GBExperienceDetailsViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/15.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBExperienceDetailsViewController: GBBaseViewController {
    var newsModel = NewsModel()
    
    var bottomView:SLGenericsNineView<GBLIRLButton,[String]>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCommentList()
        setupSubView()
    }
    
    func setupSubView() {
        view.backgroundColor = .white
        baseTableView.dataSource = self
        baseTableView.delegate = self
        baseTableView.mj_header = nil
        baseTableView.mj_footer = nil
        baseTableView.backgroundColor = .white
        baseTableView.sectionFooterHeight = 0.000001
        baseTableView.register(cellType: WeitoutiaoCell.self)
        baseTableView.register(cellType: GBDetailCommentTableViewCell.self)
        view.addSubview(baseTableView)
        
        bottomView = SLGenericsNineView(totalWidth:kScreenWidth , map: { (button, model) in
            button.isShowCenter = true
            button.setTitle(model[1], for: .normal)
            button.setTitleColor(model[1] == "赚赏金" ? kBaseColor : kNormoalTextColor, for: .normal)
            button.titleLabel?.font = XKFont.pingFangSCRegular.size(14)
            button.setImage(UIImage(named: model[0]), for: .normal)
        })
        bottomView.frame = CGRect(x: 0, y: kScreenHeight-kTabBarHeight, width: kScreenWidth, height: 49)
        bottomView.itemHeight = 49
        bottomView.everyRowCount = 3
        bottomView.dataArr = [["icon_share_blue","赚赏金"],["icon_comment","111"],["icon_Fabulous","2222"]] as [[String]]
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        self.view.bringSubviewToFront(bottomView)
        
        GBToolAddAcrossPartingLine(bottomView,color:kLineColor)
        
        bottomView.itemClicked = {(view, model, index) in
            GBLog(index)
            switch index {
            case 0:
                break
            case 1:
                let postCommentView = PostCommentView.loadFromNib()
                postCommentView.placeholderLabel.text = "优质评论将会被优先展示"
                postCommentView.isEmojiButtonSelected = false
                UIApplication.shared.keyWindow?.backgroundColor = UIColor.white.withAlphaComponent(0.85)
                UIApplication.shared.keyWindow?.addSubview(postCommentView)
                break
            default:
                break
            }
        }
    }
    
    func getCommentList() {
        let parame = ["pageNo":page,"pageSize":10,"essayId":self.newsModel.id as Any]
        NetworkTool.shared.post(UrlPath.EssayCommentList.rawValue, parameters: parame, methodLog: "评论列表") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                
            }
        }
    }
}

extension GBExperienceDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.zz_heightForCellWithIdentifier(identifier: WeitoutiaoCell.reuseIdentifier, cacheByIndexPath: indexPath as NSIndexPath, configuration: { (cell) -> () in
            guard let cell = cell as? WeitoutiaoCell else { return }
            cell.aNews = self.newsModel
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: WeitoutiaoCell.self)
        cell.isDetail = true
        cell.aNews = self.newsModel
        cell.selectionStyle = .none

        // 点击了那张图片
        cell.didSelectCell = { [weak self] (selectedIndex) in
            let previewBigImageVC = PreviewDongtaiBigImageController()
            previewBigImageVC.images = cell.aNews.images
            previewBigImageVC.selectedIndex = selectedIndex
            self!.present(previewBigImageVC, animated: false, completion: nil)
        }
        
        return cell
    }
}
