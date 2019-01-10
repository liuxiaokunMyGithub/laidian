//
//  GBEarningsHeadView.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/1.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class GBEarningsHeadView: UIImageView {
    var nineView:SLGenericsNineView<CustomNineViewItem,[String]>!
    
    lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: 44)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "收益明细"
        label.textAlignment = .center
        label.font = XKFont.pingFangSCMedium.size(18)

        return label
    }()
    lazy var subtitle:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: kStatusNavigationHeight + 8, width: kScreenWidth, height: 44)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "资产总额 (元)"
        label.textAlignment = .center
        label.font = XKFont.pingFangSCMedium.size(16)
        return label
    }()
    lazy var moneyLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: subtitle.bottom+8, width: kScreenWidth, height: 44)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.text = "21690.05"
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(_:))))

        label.textAlignment = .center
        label.font = XKFont.pingFangSCSemibold.size(46)
        return label
    }()
    lazy var withdrawalButton:UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: (kScreenWidth - 64)/2, y: self.height - 80, width: 64, height: 44)
        button.setImage(UIImage(named: "button_withdrawal"), for: .normal)
        button.addTarget(self, action: #selector(withdrawalButtonAction), for: .touchUpInside)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(subtitle)
        addSubview(moneyLabel)
        addSubview(withdrawalButton)
        
        nineView = SLGenericsNineView(totalWidth:kScreenWidth , map: { (view, model) in
            view.titleButton.setTitle(model[0], for: .normal)
            view.titleButton.setTitleColor(.white, for: .normal)
            view.titleButton.titleLabel?.font = XKFont.pingFangSCSemibold.size(26)
            
            view.subTitleButton.setTitle(model[1], for: .normal)
            view.subTitleButton.setTitleColor(.white, for: .normal)
            view.subTitleButton.titleLabel?.font = XKFont.pingFangSCMedium.size(12)
        })
        nineView.dataArr = [["1690.05","创作收入（元）"],["21836.7","其他收入（元）"],["836.7","已提现收入（元）"]] as [[String]]
        nineView.frame = CGRect(x: 0, y: moneyLabel.bottom+44, width: kScreenWidth, height: 80)
        nineView.backgroundColor = .clear
        addSubview(nineView)
        self.bringSubviewToFront(nineView)
        nineView.itemClicked = {(view, model, index) in
            GBLog(index)
        }
        self.image = UIImage(named: "earningsHeadImage")
    }
    
   @objc func withdrawalButtonAction() {
        GBLog("withdrawalButtonAction")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func tapLabel(_ gesture: UITapGestureRecognizer)  {
        print("tapLabel☄")
    }
    
    //MARK: 暂用，待优化。
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for tempView in self.subviews {
            if tempView.isKind(of: UILabel.self) {
                let button = tempView as! UILabel
                let newPoint = self.convert(point, to: button)
                if button.bounds.contains(newPoint) {
                    return true
                }
            }
        }
        return false
    }
}
