//
//  DDCollectionFlowLayout.swift
//  Swift版本的CollectionView
//
//  Created by majianjie on 2016/12/7.
//  Copyright © 2016年 ddtc. All rights reserved.
//

import UIKit

protocol UICollectionViewLayoutDelegate : class {

     func waterFlow(_ layout : DDCollectionFlowLayout,_ width : CGFloat,_ indexPath : NSIndexPath) -> CGFloat
}

class DDCollectionFlowLayout: UICollectionViewLayout {

    
    weak var delegate : UICollectionViewLayoutDelegate?
    var columnMargin :CGFloat = 10
    var rowMargin : CGFloat = 10
    var columnsCount : Int = 3
    
    var edgeInset : UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    fileprivate lazy var maxYDic : NSMutableDictionary =  {
        
        let maxYDic = NSMutableDictionary()
        
        for i in 0..<self.columnsCount{
            
            let cloumn = String(i)
            maxYDic[cloumn] = self.edgeInset.top
        }
        
        return maxYDic
    }()
    
    fileprivate var attrsArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

extension DDCollectionFlowLayout{
    
    // MARK:- 将要布局时候调用
    override func prepare() {
        
        super.prepare()
        
        //清空最大的Y值
        for i in 0..<self.columnsCount{
            let cloumn :String = String(i)
            //字典可以存放 基本数据类型当做 value
            self.maxYDic[cloumn] = self.edgeInset.top
        }
        
        self.attrsArray.removeAll()
        
        
        let count : Int! = self.collectionView?.numberOfItems(inSection: 0)
        
        for j in 0..<count {
            
            let indexPath : NSIndexPath = NSIndexPath(item: j, section: 0)
            
            let attr : UICollectionViewLayoutAttributes = self.layoutAttributesForItem(at: indexPath as IndexPath)!
            self.attrsArray.append(attr)
            
        }
        
    }
}

extension DDCollectionFlowLayout{
    
    // MARK:- 返回所有的尺寸 ,否则不能滚动
    override var collectionViewContentSize: CGSize{
        
        var maxCloumn = "0"
        
        for (column,maxY) in self.maxYDic{
            
            let ab : CGFloat = self.maxYDic[maxCloumn] as! CGFloat
            if maxY as! CGFloat  > CGFloat(ab) {
                maxCloumn = column as! String
            }
        }
        
        let size = CGSize(width: 0, height: self.maxYDic[maxCloumn] as! CGFloat + self.edgeInset.bottom)
        
        return size
        
    }
    
}

extension DDCollectionFlowLayout{
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.attrsArray
    }
    

    
}

extension DDCollectionFlowLayout{
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        var minColumn = "0"
        
        for (column,maxY) in self.maxYDic{
            
            let ab = self.maxYDic[minColumn] as! CGFloat
            let max = maxY as! CGFloat//((maxY as! String) as NSString).floatValue
            
            if CGFloat(max) < ab {
                minColumn = column as! String
            }
        }
        
        //计算尺寸
        
        let left = self.edgeInset.left
        let right = self.edgeInset.right
        let totalW = CGFloat(self.columnsCount - 1) * self.columnMargin
        
        
        let w : CGFloat = CGFloat((self.collectionView?.frame.size.width)! - left - right - totalW) / CGFloat(self.columnsCount)
        
        let h = self.delegate?.waterFlow(self, w, indexPath as NSIndexPath) ?? 100
        
        
        //计算位置
        let x: Float  = Float(self.edgeInset.left) + Float(w + self.columnMargin) * (minColumn as NSString).floatValue
        
        let y  : CGFloat = self.maxYDic[minColumn] as! CGFloat + self.rowMargin
        
        //更新 最大 Y 值
        self.maxYDic[minColumn] = ((CGFloat(y) + h) as CGFloat)
        
        
        let attr = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attr.frame = CGRect(x: CGFloat(x), y: CGFloat(y), width: CGFloat(w), height: CGFloat(h))
        
        return attr
        
    }
    
}

