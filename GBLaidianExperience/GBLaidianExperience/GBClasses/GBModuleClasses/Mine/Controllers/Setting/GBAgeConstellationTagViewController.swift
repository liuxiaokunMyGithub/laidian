//
//  GBAgeConstellationTagViewController.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/3.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

enum TagClassType:Int {
    case TagClassTypeAge = 0
    case TagClassTypeConstellation = 1
}

class GBAgeConstellationTagViewController: GBBaseViewController {
    fileprivate let ageList = [["60后", "65后", "70后", "75后", "80后", "85后"],["90后", "95后", "00后", "05后", "10后", "15后"]]
    fileprivate let constellationList = [["水瓶座", "双鱼座", "白羊座", "金牛座", "双子座", "巨蟹座"],["狮子座", "处女座", "射手座", "摩羯座", "天秤座", "天蝎座"]]
    
    var finishBlock:((_ value:String) -> ())?
    var selectTag:String?
    
    var tagClassType:TagClassType = .TagClassTypeAge
    
    private var oneLineTagView = ACTagView(frame: CGRect(x: 0, y: kStatusNavigationHeight, width:kScreenWidth, height: GBToolFitUI(220)), layoutType: .autoLineFeed)
    
    private var oneLineTagView2 = ACTagView(frame: CGRect(x: 0, y: GBToolFitUI(220), width:kScreenWidth, height: kScreenHeight-148), layoutType: .autoLineFeed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigatioinBar()
        setupNormalTagView()
    }
    
    private func setupNavigatioinBar() {
        navBar.wr_setRightButton(title: "完成", titleColor: kBaseColor)
        navBar.onClickRightButton = {
            if (self.selectTag?.length)! > 0 {
                self.finishBlock!(self.selectTag!)
                self.navigationController?.popViewController(animated: true)
            }else {
                
            }
        }
    }
    
    private func setupNormalTagView() {
        ACTagConfig.default.tagBorderType = .custom(radius: 2)
        ACTagConfig.default.selectedTagTextColor = kBaseColor
        ACTagConfig.default.tagTextColor = kAssistTextColor
        ACTagConfig.default.tagBorderColor = kLineColor
        ACTagConfig.default.selectedTagBorderColor = kBaseColor
        ACTagConfig.default.tagBorderWidth = 0.5
        
        oneLineTagView.tagWidth = (kScreenWidth - GBMargin*2) / 2 - GBMargin
        oneLineTagView.tagHeight = GBMargin*2
        oneLineTagView.margin = ACTagDistance(horizontal: 24,vertical: 20)
        oneLineTagView.tagMargin = ACTagDistance(horizontal: GBMargin,vertical: GBMargin)
        oneLineTagView.tagDataSource = self
        oneLineTagView.tagDelegate = self
        oneLineTagView.backgroundColor = UIColor.white
        oneLineTagView.tag = 0
        view.addSubview(oneLineTagView)
        
        oneLineTagView2.tagWidth = (kScreenWidth - GBMargin*2) / 2 - GBMargin
        oneLineTagView2.tagHeight = GBMargin*2
        oneLineTagView2.margin = ACTagDistance(horizontal: 24,vertical: 20)
        oneLineTagView2.tagMargin = ACTagDistance(horizontal: GBMargin,vertical: GBMargin)
        oneLineTagView2.tagDataSource = self
        oneLineTagView2.tagDelegate = self
        oneLineTagView2.backgroundColor = UIColor.white
        oneLineTagView2.tag = 1
        view.addSubview(oneLineTagView2)
    }
}

extension GBAgeConstellationTagViewController: ACTagViewDataSource {
    func numberOfTags(in tagView: ACTagView) -> Int {
        return self.tagClassType == .TagClassTypeAge ? ageList[tagView.tag].count : constellationList[tagView.tag].count
    }
    
    func tagView(_ tagView: ACTagView, tagAttributeForIndexAt index: Int) -> ACTagAttribute {
        let tag = ACTagAttribute(text: self.tagClassType == .TagClassTypeAge ? ageList[tagView.tag][index] : constellationList[tagView.tag][index])
        return tag
    }
}

extension GBAgeConstellationTagViewController: ACTagViewDelegate {
    
    func tagView(_ tagView: ACTagView, didSelectTagAt index: Int) {
        print(index)
        print("tag\(tagView.tag) selectedTagsList-----------", tagView.indexsForSelectedTags)
        if tagView.tag == 0 {
            oneLineTagView2.reloadData()
        }else {
            oneLineTagView.reloadData()
        }
        
        self.selectTag  = (self.tagClassType == .TagClassTypeAge ? ageList[tagView.tag][index] : constellationList[tagView.tag][index])
    }
    
    func tagView(_ tagView: ACTagView, didDeselectTagAt index: Int) {
        print("deselected------------",index)
    }
    
}
