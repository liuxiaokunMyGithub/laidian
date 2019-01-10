//
//  WeitoutiaoCell.swift
//  News
//
//  Created by 杨蒙 on 2018/2/3.
//  Copyright © 2018年 hrscy. All rights reserved.
//

import UIKit
import IBAnimatable
import Kingfisher

class WeitoutiaoCell: UITableViewCell, NibReusable {

    var didSelectCell: ((_ selectedIndex: Int)->())?
    
    var isDetail:Bool = false
    
    var aNews = NewsModel() {
        didSet {
            avatarImageView.kf.setImage(with: URL(string: aNews.user.avatar_url), placeholder:UIImage(named: "img_default"))
            vImageView.isHidden = !aNews.user.user_verified
            nameLabel.text = aNews.nickName
            titleLabel.text = aNews.title
            timeAndDescriptionLabel.text = aNews.displayCreateTime + (aNews.user.verified_content != "" ? (" · \(aNews.user.user_verified)") : "")
            
            likeButton.setTitle("有用 \(self.aNews.usefulCnt)", for: .normal)
            likeButton.isSelected = aNews.usefulChecked
            likeButton.contentHorizontalAlignment = .right
            
            commentButton.setTitle("评论 \(aNews.commentCount)", for: .normal)
            // 分享
            forwardButton.contentHorizontalAlignment = .left
            forwardButton.isSelected = aNews.shared
            // 关注
            concernButton.isSelected = aNews.watched

            
            // 显示 emoji
            contentLabel.preferredMaxLayoutWidth = kScreenWidth - 30
            contentLabel.numberOfLines = 3
            contentLabel.text = aNews.content
//            contentLabel.sizeToFit()
//            titleLabelHeight.constant = aNews.titleHeight
//            contentLabelHeight.constant = aNews.contentH
            middleViewHeight.constant = aNews.collectionViewH
            bottomView.isHidden = self.isDetail
            
            layoutIfNeeded()
            if middleView.contains(collectionView) { collectionView.removeFromSuperview() }
            if aNews.images.count != 0 {
                middleView.addSubview(collectionView)
                collectionView.frame = CGRect(x: 15, y: 0, width: aNews.collectionViewW, height: aNews.collectionViewH)
                collectionView.thumbImages = aNews.images
                collectionView.largeImages = aNews.large_image_list
                collectionView.isWeitoutiao = true
                collectionView.didSelect = { [weak self] (selectedIndex) in
                    self!.didSelectCell?(selectedIndex)
                }
            }
        }
    }
    /// 懒加载 collectionView
    private lazy var collectionView = DongtaiCollectionView.loadFromNib()
    /// 头像
    @IBOutlet weak var avatarImageView: AnimatableImageView!
    /// v
    @IBOutlet weak var vImageView: UIImageView!
    /// 用户名
    @IBOutlet weak var nameLabel: UILabel!
    /// 时间和描述
    @IBOutlet weak var timeAndDescriptionLabel: UILabel!
    /// 关注按钮
    @IBOutlet weak var concernButton: UIButton!
    /// 关闭按钮
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelHeight: NSLayoutConstraint!
    /// 内容
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentLabelHeight: NSLayoutConstraint!
    /// 中间的 view
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var middleViewHeight: NSLayoutConstraint!
    /// 喜欢按钮
    @IBOutlet weak var likeButton: UIButton!
    /// 评论按钮
    @IBOutlet weak var commentButton: UIButton!
    /// 转发按钮
    @IBOutlet weak var forwardButton: UIButton!
    /// 位置/阅读数量
    @IBOutlet weak var areaLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var separatorView2: UIView!
    /// 底部的 view
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var coverButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    /// 关注按钮点击
    @IBAction func concernButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
    }
    // 有用
    @IBAction func likeButtonAction(_ sender: Any) {
        NetworkTool.shared.post(UrlPath.EssayUseful.rawValue, parameters: ["id":self.aNews.id as Any], methodLog: "点击有用") { (state: ResponseStatus, result: JSON?, message: String?) in
            if state == .success {
                self.aNews.usefulCnt += 1
                self.likeButton.setTitle("有用\(self.aNews.usefulCnt)", for: .normal)
                self.likeButton.setTitleColor(kBaseColor, for: .normal)
            }
        }
    }
    
    // 评论
    @IBAction func commentButtonAction(_ sender: Any) {
        let detailVC = GBExperienceDetailsViewController()
        detailVC.newsModel = self.aNews
        GBPushNavigationController.pushViewController(detailVC, animated: true)
    }
    
    // F分享
    @IBAction func shareButtonAction(_ sender: Any) {
        self.showShareView()
    }
    
    // 分享
    func showShareView() {
        let buttonInfo = ["icon_wechat":"微信好友","icon_friends":"朋友圈"]
        let shareView = XKShareCustomView(frame:(KEYWINDOW?.bounds)! ,buttonInfo: buttonInfo)
        shareView.delegate = self
        shareView.show()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension WeitoutiaoCell: XKShareCustomViewProtocol{
    // 分享代理
    func didClickOnItemAtIndex(index: Int) {
        GBLog("分享index = \(index)")
    }
}

