//
//  UITableView+FDTemplateLayoutCell.swift
//  ZZTableViewTemplateLayoutCell
//
//  Created by duzhe on 16/4/4.
//  Copyright © 2016年 dz. All rights reserved.

import UIKit

class ZZTemplateLayoutCellHeightCache:NSObject,NSCopying{
    func copy(with zone: NSZone? = nil) -> Any {
        let theCopy = ZZTemplateLayoutCellHeightCache()
        theCopy.sections = self.sections
        return theCopy
    }
    
    
    var sections:Array = [[CGFloat]]()
    
    func copyWithZone(zone: NSZone) -> AnyObject {
        let theCopy = ZZTemplateLayoutCellHeightCache()
        theCopy.sections = self.sections
        return theCopy
    }
    
    // 标记没有被cache的值
    static let ZZTemplateLayoutCellHeightCacheAbsentValue:CGFloat = -1
    
    /**
     初始化Height缓存数组 对每个元素做标记
     
     - parameter indexPaths: indexPaths数组
     */
    func buildHeightCachesAtIndexPathsIfNeeded(indexPaths:[NSIndexPath]){
        guard indexPaths.count > 0 else { return }
        indexPaths.forEach { (indexPath) -> () in
            //如果section 数组里面还没有 创建一个对象的空数组
            if indexPath.section >= self.sections.count{
                self.sections.insert([], at: indexPath.section)
            }
            
            var rows = self.sections[indexPath.section]
            //如果对应的row不存在 创建一个并标记为没有被cache
            if indexPath.row >= rows.count {
                rows.insert(ZZTemplateLayoutCellHeightCache.ZZTemplateLayoutCellHeightCacheAbsentValue, at: indexPath.row)
            }
            self.sections[indexPath.section] = rows
        }
        
    }
    
    /**
     indexPath是否已经被缓存
     
     - parameter indexPath: indexPath
     
     - returns: Bool
     */
    func hasCachedHeightAtIndexPath(indexPath:NSIndexPath)->Bool{
        
        self.buildHeightCachesAtIndexPathsIfNeeded(indexPaths: [indexPath])
        return self.sections[indexPath.section][indexPath.row] != ZZTemplateLayoutCellHeightCache.ZZTemplateLayoutCellHeightCacheAbsentValue
        
    }
    
    /**
     缓存高度
     
     - parameter height:    高度
     - parameter indexPath: indexPath索引
     */
    func cacheHeight(height:CGFloat,byIndexPath indexPath:NSIndexPath){
        
        self.buildHeightCachesAtIndexPathsIfNeeded(indexPaths: [indexPath])
        self.sections[indexPath.section][indexPath.row] = height
        
    }
    
    /**
     获取已经缓存的height
     
     - parameter indexPath: indexPath索引
     
     - returns: height
     */
    func cachedHeightAtIndexPath(indexPath:NSIndexPath)->CGFloat{
        self.buildHeightCachesAtIndexPathsIfNeeded(indexPaths: [indexPath])
        return self.sections[indexPath.section][indexPath.row]
    }
}

extension UITableView{
    
    private struct AssociatedKeys{
        static var zz_debugLogEnabled = "zz_debugLogEnabled"
        static var zz_chc = "zz_chc"
        static var zz_tmpCellForReuseId = "zz_tmpCellForReuseId"
        static var zz_autoCacheInvalidationEnabled = "zz_autoCacheInvalidationEnabled"
        static var zz_precacheEnabled = "zz_precacheEnabled"
    }
    
    /// 扩展 添加属性 是否在debug的情况下打印
    var zz_debugLogEnabled:Bool? {
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.zz_debugLogEnabled,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.zz_debugLogEnabled) as? Bool
        }
    }
    
    
    private var zz_chc:ZZTemplateLayoutCellHeightCache?{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.zz_chc,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.zz_chc) as? ZZTemplateLayoutCellHeightCache
        }
    }
    
    private var zz_tmpCellForReuseId:[String:UITableViewCell]?{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.zz_tmpCellForReuseId,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.zz_tmpCellForReuseId) as? [String:UITableViewCell]
        }
    }
    
    var zz_autoCacheInvalidationEnabled:Bool?{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.zz_autoCacheInvalidationEnabled,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.zz_autoCacheInvalidationEnabled) as? Bool
        }
    }
    
    var zz_precacheEnabled:Bool?{
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.zz_precacheEnabled,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.zz_precacheEnabled) as? Bool
        }
    }
    
    
    /**
     打印 根据是否在debug还有zz_debugLogEnabled属性
     
     - parameter message: 打印的内容
     */
    func zz_debugLog(message:String){
        #if DEBUG
        if self.zz_debugLogEnabled != nil && self.zz_debugLogEnabled!{
                print(message)
            }
        #endif
    }

    /**
     根据identifier获取UITableViewCell
     
     - parameter identifier: identifier
     
     - returns: UITableViewCell
     */
    func zz_templateCellForReuseIdentifier(identifier:String)->UITableViewCell{
        assert(identifier.characters.count>0, "需要一个正确的identifier - \(identifier)")
        
        if zz_tmpCellForReuseId == nil {
            zz_tmpCellForReuseId = [:]
        }
        var templateCell = zz_tmpCellForReuseId![identifier]
        if templateCell == nil{
            
            templateCell = self.dequeueReusableCell(withIdentifier: identifier)
            assert(templateCell != nil, "cell必须已经用identifier注册过: - \(identifier)")
            templateCell!.zz_isTemplateLayoutCell = true
            zz_tmpCellForReuseId![identifier] = templateCell
            self.zz_debugLog(message: "cell布局已经创建: - \(identifier)")
        }
        
        return templateCell!
    }
    
    /**
     返回ZZTemplateLayoutCellHeightCache的一个实例对象 如果已经存在直接获取
     
     - returns: ZZTemplateLayoutCellHeightCache对象
     */
    func zz_cellHeightCache()->ZZTemplateLayoutCellHeightCache{
        if zz_chc == nil{
            zz_chc = ZZTemplateLayoutCellHeightCache()
        }
        return self.zz_chc!
    }
    
}

// MARK: - cell的预缓存
extension UITableView{
    
    private func zz_precacheIfNeeded(){
        
        if let pe = self.zz_precacheEnabled, !pe {
            return
        }
        guard let delegate = self.delegate else { return }
        
        if !delegate.responds(to: #selector(UITableViewDelegate.tableView(_:heightForRowAt:))){
            return
        }
        
        let runLoop = CFRunLoopGetCurrent()
        //一个空闲的Runloop ，当页面滚动时会切换到"UITrackingRunLoopMode"
        let runLoopMode = CFRunLoopMode.defaultMode
        
        // 收集所有被缓存过的index paths
        var mutableIndexPathsToBePrecached = self.zz_allIndexPathsToBePrecached()
        
        let observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, CFRunLoopActivity.beforeWaiting.rawValue, true, 0) { (observer, _) -> Void in
            // 所有预缓存任务完成的时候 移除Observer
            if mutableIndexPathsToBePrecached.count == 0{
                CFRunLoopRemoveObserver(runLoop, observer, runLoopMode)
                return
            }
            
            // 取出第一个indexPath作为此Runloop迭代的任务
            let indexPath = mutableIndexPathsToBePrecached.first
            mutableIndexPathsToBePrecached.removeFirst()
//            这个方法将创建一个 Source 0 任务，分发到指定线程的 RunLoop 中，在给定的 Mode 下执行，若指定的 RunLoop 处于休眠状态，则唤醒它处理事件
            self.perform(Selector(("zz_precacheIndexPathIfNeeded:")), on: Thread.main, with: indexPath, waitUntilDone: false, modes: [RunLoop.Mode.default.rawValue])
        }
        
        CFRunLoopAddObserver(runLoop, observer, runLoopMode)
        
    }
    
    
    /**
     如果没有缓存的话 就缓存高度
     
     - parameter indexPath: indexpath
     */
    func zz_precacheIndexPathIfNeeded(indexPath:NSIndexPath){
        guard let delegate = self.delegate else { return }
        if !self.zz_cellHeightCache().hasCachedHeightAtIndexPath(indexPath: indexPath){
            let height = delegate.tableView!(self, heightForRowAt: indexPath as IndexPath)
            self.zz_cellHeightCache().cacheHeight(height: height, byIndexPath: indexPath)
            self.zz_debugLog(message: "Precached - \(indexPath.section) , \(indexPath.row) , \(height)")
        }
    }
    
    /**
     获取所有需要被缓存的indexPath
     
     - returns: [indexpath]
     */
    func zz_allIndexPathsToBePrecached()->[NSIndexPath]{
        
        var allIndexPaths:[NSIndexPath] = []
        for section in 0..<self.numberOfSections{
            for row in 0..<self.numberOfRows(inSection: section){
                
                print("section is :\(section) , row is :\(row) ")
                let indexPath = NSIndexPath(row: row, section: section)
                if !self.zz_cellHeightCache().hasCachedHeightAtIndexPath(indexPath: indexPath){
                    allIndexPaths.append(indexPath)
                }
                
            }
        }
        return allIndexPaths
    }
    
}


extension  UITableView:WRAwakeProtocol {
    public static func wrAwake() {
        // 所有有可能要修改height缓存的方法
        let selectors = [
            #selector(UICollectionView.reloadData),
            #selector(UITableView.insertSections(_:with:)),
            #selector(UITableView.deleteSections(_:with:)),
            #selector(UITableView.reloadSections(_:with:)),
            #selector(UICollectionView.moveSection(_:toSection:)),
            #selector(UITableView.insertRows(at:with:)),
            #selector(UITableView.deleteRows(at:with:)),
            #selector(UITableView.reloadRows(at:with:)),
            #selector(UITableView.moveRow(at:to:))
        ]
        
        // 对所有method转换成我们自己写的method
        for index in 0..<selectors.count{
            
            let originalSelector = selectors[index]
            let swizzledSelector = NSSelectorFromString("zz_\(NSStringFromSelector(originalSelector))")
            
            let originalMethod = class_getInstanceMethod(self, originalSelector)
            let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
            
            let didAddMethod = class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!))
            
            if didAddMethod {
                class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
            } else {
                method_exchangeImplementations(originalMethod!, swizzledMethod!);
            }
            
        }
        
    }
    
    
    /**
      相当于 oc中的load类方法 在方法加载的第一时间执行
     */
//    open override static func initialize()
    
    func zz_reloadData(){
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto{
            self.zz_cellHeightCache().sections.removeAll()
        }
        self.zz_reloadData()
        self.zz_precacheIfNeeded()
    }
    
    func zz_insertSections(sections: NSIndexSet, withRowAnimation animation: UITableView.RowAnimation){
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            sections.forEach({ (index) -> () in
                self.zz_cellHeightCache().sections.insert([], at: index)
            })
        }
        
        self.zz_insertSections(sections: sections, withRowAnimation: animation)
        self.zz_precacheIfNeeded()
    }
    
    func zz_deleteSections(sections: NSIndexSet, withRowAnimation animation: UITableView.RowAnimation){
    
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            sections.forEach({ (index) -> () in
                self.zz_cellHeightCache().sections.remove(at: index)
            })
        }
        self.zz_deleteSections(sections: sections, withRowAnimation: animation)
    }
    
    func zz_reloadSections(sections: NSIndexSet, withRowAnimation animation: UITableView.RowAnimation){
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            sections.forEach({ (index) -> () in
                var rows = self.zz_cellHeightCache().sections[index]
                for row in 0..<rows.count{
                    
                    rows[row] = ZZTemplateLayoutCellHeightCache.ZZTemplateLayoutCellHeightCacheAbsentValue
                    
                }
            })
        }
        
        self.zz_reloadSections(sections: sections, withRowAnimation: animation)
        self.zz_precacheIfNeeded()
    }
    
    func zz_moveSection(section: Int, toSection newSection: Int){
        
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            self.zz_cellHeightCache().sections.exchange(index: section, withIndex: newSection)
        }
        
        self.zz_moveSection(section: section, toSection: newSection) //原始cell没有修改
    }
    
    func zz_insertRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableView.RowAnimation){
    
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            indexPaths.forEach({ (indexPath) -> () in
                
                var rows = self.zz_cellHeightCache().sections[indexPath.section]
                rows.insert(ZZTemplateLayoutCellHeightCache.ZZTemplateLayoutCellHeightCacheAbsentValue, at: indexPath.row)
                
            })
        }
        
        self.zz_insertRowsAtIndexPaths(indexPaths: indexPaths, withRowAnimation: animation)
        self.zz_precacheIfNeeded()
    }
    
    func zz_deleteRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableView.RowAnimation){
    
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            
            indexPaths.forEach({ (indexPath) -> () in
                self.zz_cellHeightCache().sections[indexPath.section].remove(at:indexPath.row)
                
            })
            
        }
        
        self.zz_deleteRowsAtIndexPaths(indexPaths: indexPaths, withRowAnimation: animation) //原始的cell
    }
    
    func zz_reloadRowsAtIndexPaths(indexPaths: [NSIndexPath], withRowAnimation animation: UITableView.RowAnimation){
    
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            
            indexPaths.forEach({ (indexPath) -> () in
                
                self.zz_cellHeightCache().sections[indexPath.section][indexPath.row] = ZZTemplateLayoutCellHeightCache.ZZTemplateLayoutCellHeightCacheAbsentValue
            })
        }
        
        self.zz_reloadRowsAtIndexPaths(indexPaths: indexPaths, withRowAnimation: animation)
        self.zz_precacheIfNeeded()
    }
    
    func zz_moveRowAtIndexPath(indexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath){
        
        if let zz_auto = self.zz_autoCacheInvalidationEnabled, zz_auto {
            
            (self.zz_cellHeightCache().sections[indexPath.section][indexPath.row],self.zz_cellHeightCache().sections[newIndexPath.section][newIndexPath.row])
            = (self.zz_cellHeightCache().sections[newIndexPath.section][newIndexPath.row],self.zz_cellHeightCache().sections[indexPath.section][indexPath.row])
        }
        
        self.zz_moveRowAtIndexPath(indexPath: indexPath, toIndexPath: newIndexPath)
    }
    
    
}

// MARK: - [Public] 提供给外部的方法
extension UITableView{

    /**
     计算获得height
     
     - parameter identifier:    id
     - parameter configuration: configuration
     
     - returns: height
     */
    func zz_heightForCellWithIdentifier(identifier:String,configuration:((_ cell:UITableViewCell)->())?)->CGFloat{
        // 通过id获取一个cell
        let cell = self.zz_templateCellForReuseIdentifier(identifier: identifier)
        //手动调用已确保和屏幕上显示的保持一致
        cell.prepareForReuse()
        configuration?(cell)
        
        //手动添加一个约束 确保动态内容 如label
        let tempWidthConstraint = NSLayoutConstraint(item: cell.contentView,
                                                     attribute: NSLayoutConstraint.Attribute.width,
                                                     relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1.0,
            constant: self.frame.width)
        
        cell.contentView.addConstraint(tempWidthConstraint)
        
        // 算出size
        let fittingSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // 移除约束
        cell.contentView.removeConstraint(tempWidthConstraint)
        
        return fittingSize.height
    }
    
    /**
     供外界使用的方法 提供了高度的缓存
     
     - parameter identifier:    identifier
     - parameter indexPath:     indexPath
     - parameter configuration: 供外部使用的闭包
     - returns: Height
     */
    func zz_heightForCellWithIdentifier(identifier:String,cacheByIndexPath indexPath:NSIndexPath,configuration:((_ cell:UITableViewCell)->())?)->CGFloat{
    
        if self.zz_autoCacheInvalidationEnabled == nil{
            self.zz_autoCacheInvalidationEnabled = true
        }
        
        if self.zz_precacheEnabled == nil{
            self.zz_precacheEnabled = true
        }
//        print("cache : \(indexPath.section) , \(indexPath.row)")
        // 如果存在缓存 从缓存中返回
        if self.zz_cellHeightCache().hasCachedHeightAtIndexPath(indexPath: indexPath){
            self.zz_debugLog(message: "cache : \(indexPath.section) , \(indexPath.row) , \(self.zz_cellHeightCache().cachedHeightAtIndexPath(indexPath: indexPath))")
            return self.zz_cellHeightCache().cachedHeightAtIndexPath(indexPath: indexPath)
        }
        
        //计算 
        let height = self.zz_heightForCellWithIdentifier(identifier: identifier, configuration: configuration)
        
        self.zz_debugLog(message: "计算出的cache cache : \(indexPath.section) , \(indexPath.row) , \(height)")
        
        //缓存
        self.zz_cellHeightCache().cacheHeight(height: height, byIndexPath: indexPath)
        
        return height
    }
    
}



extension UITableViewCell{
    //在私有嵌套 struct 中使用 static var，这样会生成我们所需的关联对象键，但不会污染整个命名空间。
    private struct AssociatedKeys{
        static var zz_isTemplateLayoutCell = "zz_isTemplateLayoutCell"
    }
    
    ///扩展 添加属性 是否为临时布局的cell
    var zz_isTemplateLayoutCell:Bool? {
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.zz_isTemplateLayoutCell,newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.zz_isTemplateLayoutCell) as? Bool
        }
    }
    
}


extension Array{
    
    mutating func exchange(index:Int,withIndex:Int){
        guard self.count > Swift.max(index,withIndex) else {  fatalError("数组越界") }
        (self[index],self[withIndex]) = (self[withIndex],self[index])
    }
    
}


///// 定义 `protocol`
//public protocol GBSelfAware: class {
//    static func awake()
//}
//
//// 创建代理执行单例
//class GBNothingToSeeHere {
//
//    static func GBharmlessFunction(){
//        let typeCount = Int(objc_getClassList(nil, 0))
//        let  types = UnsafeMutablePointer<AnyClass?>.allocate(capacity: typeCount)
//        let gbautoreleaseintTypes = AutoreleasingUnsafeMutablePointer<AnyClass?>(types)
//        objc_getClassList(gbautoreleaseintTypes, Int32(typeCount)) //获取所有的类
//        for index in 0 ..< typeCount{
//            (types[index] as? GBSelfAware.Type)?.awake() //如果该类实现了SelfAware协议，那么调用awake方法
//        }
//        types.deallocate(capacity: typeCount)
//    }
//}
//
///// 执行单例
//extension UIApplication {
//    private static let runOnce:Void = {
//        //使用静态属性以保证只调用一次(该属性是个方法)
//        NothingToSeeHere.harmlessFunction()
//        UITableView.GBharmlessFunction()
//    }()
//
//    open override var next: UIResponder?{
//        UIApplication.runOnce
//        return super.next
//    }
//}
