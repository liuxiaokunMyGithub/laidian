//
//  HotCityTableViewCell.swift
//  SoolyWeather
//
//  Created by SoolyChristina on 2017/3/9.
//  Copyright © 2017年 SoolyChristina. All rights reserved.
//

import UIKit


class HotCityTableViewCell: GBBaseTableViewCell {
    /// 懒加载 热门城市
    var cityClicked:SelectCityBlock?
    /// 懒加载 热门城市
    lazy var hotCities: [String] = {
        let path = Bundle.main.path(forResource: "hotCities.plist", ofType: nil)
        let array = NSArray(contentsOfFile: path!) as? [String]
        return array ?? []
    }()
    
    override func configUI() {
        self.backgroundColor = kBackgroundColor
        // 动态创建城市btn
        for i in 0..<hotCities.count {
            // 列
            let column = i % 3
            // 行
            let row = i / 3
            
            let btn = UIButton(frame: CGRect(x: btnMargin + CGFloat(column) * (btnWidth + btnMargin), y: 15 + CGFloat(row) * (btnHeight + btnMargin), width: btnWidth, height: btnHeight))
            btn.setTitle(hotCities[i], for: .normal)
            btn.setTitleColor(kImportantTextColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.backgroundColor = UIColor.white
//            btn.layer.borderColor = mainColor.cgColor
//            btn.layer.borderWidth = 0.5
            btn.layer.cornerRadius = 1
            btn.setBackgroundImage(btnHighlightImage, for: .highlighted)
            btn .addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            self.addSubview(btn)
            
        self.addSubview(baseLineView)
        baseLineView.snp.makeConstraints { (make) in
                make.left.equalTo(self)
                make.right.equalTo(self)
                make.height.equalTo(0.5)
                make.bottom.equalTo(self)
            }
        }
    }
    
    @objc private func btnClick(btn: UIButton) {
        print(btn.titleLabel?.text! as Any)
        
        cityClicked!((btn.titleLabel?.text!)!)
    }

}
