//
//  PhotoBrowseCollectionVC.swift
//  PhotoBrowse
//
//  Created by Jack.Ma on 16/4/28.
//  Copyright © 2016年 Jack.Ma. All rights reserved.
//

import UIKit

private let cellMargin: CGFloat = 15.0
/// MARK: - CollectionViewControll Init
class PhotoBrowseCollectionVC: UICollectionViewController {
    
    var items: [ShopModel]!
    var indexPaht: IndexPath!
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    convenience init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width + cellMargin, height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        self.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// MARK: - CollectionView life circle
private let cellID = "PhotoBrowseCellID"
extension PhotoBrowseCollectionVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.frame = UIScreen.main.bounds
        collectionView?.frame.size.width = UIScreen.main.bounds.size.width + cellMargin
        
        collectionView?.isPagingEnabled = true
        
        collectionView?.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
        collectionView?.scrollToItem(at: indexPaht!, at: .left, animated: false)
    }
}

/// MARK: - UICollectionview DataSource&Delegate
extension PhotoBrowseCollectionVC {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return (items?.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CollectionViewCell
        
        let item = items![indexPath.item]
        item.showBigImage = true
        cell.item = item
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
    }
}








