//
//  USearchViewController.swift
//  U17
//
//  Created by charles on 2017/11/10.
//  Copyright © 2017年 None. All rights reserved.
//

import UIKit
//import Moya

class USearchViewController: UBaseViewController {
    
//    private var currentRequest: Cancellable?
    
    private var hotItems: [SearchItemModel]?
    
    private var relative: [SearchItemModel]?
    
    private var comics: [ComicModel]?
    
    private lazy var searchHistory: [String]! = {
        return UserDefaults.standard.value(forKey: UDK_SearchHistory) as? [String] ?? [String]()
    }()
    
    private lazy var searchBar: UIView = {
        let search = UIView()
        search.frame = CGRect(x: 0, y: 0, width: kScreenWidth - 50, height: GBToolFitUI(32))
        search.backgroundColor = kSegmentateLineColor
        let imageIcon = UIImageView.init(frame: CGRect(x: 8, y: 7, width: 18, height: 18))
        imageIcon.image = UIImage(named: "icon_search_gray")
        search.addSubview(imageIcon)
        imageIcon.centerY = search.centerY
        GBToolConfigRadius(search, radius: 2)
        return search
    }()
    private lazy var searchTextField: UITextField = {
        let sr = UITextField()
        sr.frame = CGRect(x: 20, y: 0, width: kScreenWidth - 100, height: GBToolFitUI(32))

        sr.backgroundColor = UIColor.clear
        sr.textColor = UIColor.gray
        sr.tintColor = UIColor.darkGray
        sr.font = XKFont.pingFangSCRegular.size(16)
        sr.placeholder = "请输入搜索内容"
        sr.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        sr.leftViewMode = .always
        sr.clearsOnBeginEditing = true
        sr.clearButtonMode = .whileEditing
        sr.returnKeyType = .search
        sr.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: UITextField.textDidChangeNotification, object: sr)
        return sr
    }()
    
    private lazy var historyTableView: UITableView = {
        let tw = UITableView(frame: CGRect.zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.separatorStyle = .none
        tw.backgroundColor = .white
        tw.register(headerFooterViewType: USearchTHead.self)
        tw.register(cellType: GBBaseTableViewCell.self)
        tw.register(cellType: GBSearchHotCell.self)
        return tw
    }()
    
    
    lazy var searchTableView: UITableView = {
        let sw = UITableView(frame: CGRect.zero, style: .grouped)
        sw.delegate = self
        sw.dataSource = self
        sw.backgroundColor = .white
        sw.register(headerFooterViewType: USearchTHead.self)
        sw.register(cellType: GBBaseTableViewCell.self)
        return sw
    }()
    
    lazy var resultTableView: UITableView = {
        let rw = UITableView(frame: CGRect.zero, style: .grouped)
        rw.delegate = self
        rw.dataSource = self
        rw.backgroundColor = .white
        rw.register(cellType: GBBaseTableViewCell.self)
        return rw
    }()
    
    
    lazy var clearButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 180, height: 80))
        button.setTitle("清空搜索记录", for: .normal)
        button.setTitleColor(kRedTextColor, for: .normal)
        button.addTarget(self, action: #selector(clearSeachHistory), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadHistory()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadHistory() {
        historyTableView.isHidden = false
        searchTableView.isHidden = true
        resultTableView.isHidden = true
//        ApiLoadingProvider.request(UApi.searchHot, model: HotItemsModel.self) { (returnData) in
//            self.hotItems = returnData?.hotItems
//            self.historyTableView.reloadData()
//        }
        let hots = NSMutableArray.init()
        for index in ["校园","大连","职场","生活","窍门","区块链"] {
            var item = SearchItemModel()
            item.name = index
            hots.add(item)
        }
        self.hotItems = (hots as! [SearchItemModel])
        self.historyTableView.reloadData()
    }
    
    private func searchRelative(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = false
            resultTableView.isHidden = true
//            currentRequest?.cancel()
//            currentRequest = ApiProvider.request(UApi.searchRelative(inputText: text), model: [SearchItemModel].self) { (returnData) in
//                self.relative = returnData
//                self.searchTableView.reloadData()
//            }
        } else {
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }
    
    private func searchResult(_ text: String) {
        if text.count > 0 {
            historyTableView.isHidden = true
            searchTableView.isHidden = true
            resultTableView.isHidden = false
            searchTextField.text = text
//            ApiLoadingProvider.request(UApi.searchResult(argCon: 0, q: text), model: SearchResultModel.self) { (returnData) in
//                self.comics = returnData?.comics
//                self.resultTableView.reloadData()
//            }
            
            let defaults = UserDefaults.standard
            var histoary = defaults.value(forKey: UDK_SearchHistory) as? [String] ?? [String]()
            histoary.removeAll([text])
            histoary.insertFirst(text)
            
            searchHistory = histoary
            historyTableView.reloadData()
            
            defaults.set(searchHistory, forKey: UDK_SearchHistory)
            defaults.synchronize()
        } else {
            historyTableView.isHidden = false
            searchTableView.isHidden = true
            resultTableView.isHidden = true
        }
    }

    
    override func configUI() {
        super.configUI()
        view.backgroundColor = .white
        view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints { $0.edges.equalTo(self.view.safeSnp.edges) }
        historyTableView.tableFooterView = clearButton
        
        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints { $0.edges.equalTo(self.view.safeSnp.edges) }
        
        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { $0.edges.equalTo(self.view.safeSnp.edges) }
    }
    
    override func configNavigationBar() {
        super.configNavigationBar()
        searchBar.addSubview(searchTextField)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self,
                                                            action: #selector(cancelAction))
    }
    
    @objc private func cancelAction() {
        searchTextField.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
   @objc private func clearSeachHistory () {
        self.searchHistory?.removeAll()
        self.historyTableView.reloadData()
        UserDefaults.standard.removeObject(forKey: UDK_SearchHistory)
        UserDefaults.standard.synchronize()
    }
}

extension USearchViewController: UITextFieldDelegate {
    
    @objc func textFiledTextDidChange(noti: Notification) {
        guard let textField = noti.object as? UITextField,
            let text = textField.text else { return }
        searchRelative(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        searchResult(text!)
        return textField.resignFirstResponder()
    }
}

extension USearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTableView {
            return searchHistory.count > 0 ? 2 : 1
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return section == 1 ? (searchHistory?.prefix(10).count ?? 0) : 1
        } else if tableView == searchTableView {
            return relative?.count ?? 0
        } else {
            return comics?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return 44
        } else if tableView == searchTableView {
            return comics?.count ?? 0 > 0 ? 44 : CGFloat.leastNormalMagnitude
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return 0.00001
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        } else {
            if tableView == historyTableView && indexPath.section == 0 {
                return 100
            }
            return GBToolFitUI(50)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTableView {
            let head = tableView.dequeueReusableHeaderFooterView(USearchTHead.self)
            head?.imageSize = CGSize(width: 25, height: 25)
            head?.baseTitleLabel.text = section == 0  ? "热门推荐" : "搜索历史"
            head?.baseImageView.image = (section == 0 ? UIImage(named: "icon_fire") : UIImage(named: "icon_History"))
            head?.moreButton.isHidden = section == 0 ? (searchHistory.count == 0) : false
            head?.moreActionClosure { [weak self] in
                if section == 1 {
                    self?.searchHistory?.removeAll()
                    self?.historyTableView.reloadData()
                    UserDefaults.standard.removeObject(forKey: UDK_SearchHistory)
                    UserDefaults.standard.synchronize()
                } else {
                    self?.loadHistory()
                }
            }
            return head
        } else if tableView == searchTableView {
            let head = tableView.dequeueReusableHeaderFooterView(USearchTHead.self)
            head?.baseTitleLabel.text = "找到相关的漫画 \(comics?.count ?? 0) 本"
            head?.moreButton.isHidden = true
            return head
        } else {
            return nil
        }
        
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBSearchHotCell.self)
                cell.data = self.hotItems!
                return cell
            }
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBBaseTableViewCell.self)
            cell.imageSize = CGSize(width: 16, height: 16)
            cell.linWidth = kScreenWidth
            cell.cellStyle = .BaseCellStyleImageDefault
            cell.baseTitleLabel.text = searchHistory?[indexPath.row]
            cell.baseImageView.image = UIImage(named: "icon_time")
            cell.baseIndicateButton.setImage(UIImage(named: "icon_delete"), for: .normal)
            cell.baseTitleLabel.textColor = kAssistTextColor
            return cell
        } else if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBBaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        } else if tableView == resultTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBBaseTableViewCell.self)
//            cell.model = comics?[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: GBBaseTableViewCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            searchResult(searchHistory[indexPath.row])
        } else if tableView == searchTableView {
            searchResult(relative?[indexPath.row].name ?? "")
        } else if tableView == resultTableView {
            guard let model = comics?[indexPath.row] else { return }
//            let vc = UComicViewController(comicid: model.comicId)
//            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
   
}


