//
//  ViewController.swift
//  Swift版本的CollectionView
//
//  Created by majianjie on 2016/12/7.
//  Copyright © 2016年 ddtc. All rights reserved.
//

import UIKit
import MJExtension

let ID : String = "DDCollectionCell"

class ViewController: UIViewController,UICollectionViewDelegate {

    open var collectionView:UICollectionView!
    fileprivate var shops:[ShopModel] = [ShopModel]()
    fileprivate lazy var modalDelegate: ModalAnimationDelegate = ModalAnimationDelegate()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
      let shops =  ShopModel.mj_objectArray(withFilename: "1.plist")
        
        for shop in shops!{
            
            self.shops.append(shop as! ShopModel)
            
        }
        
        let layout = DDCollectionFlowLayout()
        layout.delegate = self
        
        self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.addSubview(self.collectionView)
       
        let nib = UINib(nibName: "DDCollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: ID)
    
    }

}

extension ViewController : UICollectionViewDataSource{
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : DDCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath) as! DDCollectionCell
        
        cell.setShops(self.shops[indexPath.item])
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: UICollectionViewScrollPosition.bottom)
    
            let photoVC = PhotoBrowseCollectionVC()
            photoVC.indexPaht = indexPath
            photoVC.items = self.shops
            photoVC.transitioningDelegate = modalDelegate
            photoVC.modalPresentationStyle = .custom
            present(photoVC, animated: true, completion: nil)
        
    }
    
}

extension ViewController:UICollectionViewLayoutDelegate{
    
    func waterFlow(_ layout : DDCollectionFlowLayout,_ width : CGFloat,_ indexPath : NSIndexPath) -> CGFloat
    {
        
        let shop = self.shops[indexPath.item] as ShopModel
        
        let h = ((shop.h) as NSString).floatValue
        let w = ((shop.w) as NSString).floatValue
        
        return CGFloat( h / w ) * width
        
        
    }
    
}

