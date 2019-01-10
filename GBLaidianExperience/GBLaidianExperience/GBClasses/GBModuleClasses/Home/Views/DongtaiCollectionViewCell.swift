//
//  DongtaiCollectionViewCell.swift
//  News
//
//  Created by 杨蒙 on 2017/12/10.
//  Copyright © 2017年 hrscy. All rights reserved.
//

import UIKit
import Kingfisher

class DongtaiCollectionViewCell: UICollectionViewCell ,NibReusable {
    
    var isPostSmallVideo = false {
        didSet {
//            iconButton.theme_setImage(isPostSmallVideo ? "images.smallvideo_all_32x32_" : nil, forState: .normal)
        }
    }
    
    var thumbImage = String() {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: BASE_URL_IMAGE_QINIUYUN + thumbImage)!)
//            gifLabel.isHidden = !(thumbImage.type == .gif)
        }
    }
    
    var largeImage = String() {
        didSet {
            thumbImageView.kf.setImage(with: URL(string: BASE_URL_IMAGE_QINIUYUN + largeImage), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                let progress = Float(receivedSize) / Float(totalSize)
//                SVProgressHUD.showProgress(progress)
//                SVProgressHUD.setBackgroundColor(.clear)
//                SVProgressHUD.setForegroundColor(UIColor.white)
            }) { (image, error, cacheType, url) in
//                SVProgressHUD.dismiss()
            }
        }
    }
    
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var iconButton: UIButton!
    
    @IBOutlet weak var gifLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        thumbImageView.layer.theme_borderColor = "colors.grayColor230"
//        thumbImageView.layer.borderWidth = 1
//        theme_backgroundColor = "colors.cellBackgroundColor"
    }

}
