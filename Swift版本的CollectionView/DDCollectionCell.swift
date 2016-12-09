//
//  DDCollectionCell.swift
//  Swift版本的CollectionView
//
//  Created by majianjie on 2016/12/7.
//  Copyright © 2016年 ddtc. All rights reserved.
//

import UIKit
import SDWebImage

class DDCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var priceLabel: UILabel!
    
    var shop : ShopModel!
    
    
    func setShops(_ shop:ShopModel) {
        
        self.shop = shop

        self.imageView.sd_setImage(with: NSURL(string: shop.img)! as URL, placeholderImage: UIImage(named:"loading")!)
        
        self.priceLabel.text = shop.price;
        
    }
    

}
