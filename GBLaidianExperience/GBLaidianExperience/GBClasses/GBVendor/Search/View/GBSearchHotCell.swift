//
//  GBSearchHotCell.swift
//  GBLaidianExperience
//
//  Created by 刘小坤 on 2018/11/6.
//  Copyright © 2018年 gebikeji. All rights reserved.
//

import UIKit

class USearchCCell: GBBaseCollectionViewCell {
    lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textAlignment = .center
        tl.font = XKFont.pingFangSCMedium.size(16)
        tl.textColor = kBaseColor
        return tl
    }()
    lazy var line: UILabel = {
        let tl = UILabel()
        tl.backgroundColor = kLineColor
        return tl
    }()
    override func configUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(line)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)) }
        line.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.width.equalTo(1)
            $0.right.equalTo(contentView)
            $0.centerY.equalTo(contentView)
        }
        
    }
}

typealias GBSearchHotCellDidSelectIndexClosure = (_ index: Int, _ model: SearchItemModel) -> Void

protocol GBSearchHotCellDelegate: class {
    func searchTFoot(_ searchTFoot: GBSearchHotCell, didSelectItemAt index: Int, _ model: SearchItemModel)
}

class GBSearchHotCell: GBBaseTableViewCell {
    weak var delegate: GBSearchHotCellDelegate?
    
    private var didSelectIndexClosure: GBSearchHotCellDidSelectIndexClosure?
    
    private lazy var collectionView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        lt.minimumInteritemSpacing = 10
        lt.minimumLineSpacing = 10
        lt.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        lt.itemSize = CGSize(width: (kScreenWidth-80)/4, height: 40)
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor.white
        cw.dataSource = self
        cw.delegate = self
        cw.register(cellType: USearchCCell.self)
        return cw
    }()
    
    var data: [SearchItemModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func configUI() {
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension GBSearchHotCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: USearchCCell.self)
        cell.layer.cornerRadius = cell.bounds.height * 0.5
        cell.titleLabel.text = data[indexPath.row].name
        cell.line.isHidden =  (indexPath.row != 0 && indexPath.row % 3 == 0) ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTFoot(self, didSelectItemAt: indexPath.row, data[indexPath.row] )
        
        guard let closure = didSelectIndexClosure else { return }
        closure(indexPath.row, data[indexPath.row])
    }
    
    func didSelectIndexClosure(_ closure: @escaping GBSearchHotCellDidSelectIndexClosure) {
        didSelectIndexClosure = closure
    }
}
