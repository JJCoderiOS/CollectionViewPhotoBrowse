//
//  ModalAnimationDelegate.swift
//  PhotoBrowse
//
//  Created by Jack.Ma on 16/4/28.
//  Copyright © 2016年 Jack.Ma. All rights reserved.
//

import UIKit

class ModalAnimationDelegate: NSObject, UIViewControllerTransitioningDelegate{
    fileprivate var isPresentAnimationing: Bool = true
}

extension ModalAnimationDelegate: UIViewControllerAnimatedTransitioning {
    // MARK:- 刚刚开始present时候调用
     func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimationing = true
        return self
     }
    
     func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresentAnimationing = false
        return self
    }
}

extension ModalAnimationDelegate {
    // MARK:- 动画执行时长
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        //判断是弹出还是消失
        isPresentAnimationing ? presentViewAnimation(transitionContext) : dismissViewAnimation(transitionContext)
        
    }
    
    func presentViewAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        
        // 过渡view
        let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        // 容器view
        let containerView = transitionContext.containerView
        guard let _ = destinationView else {
            return
        }
        // 过渡view添加到容器view上
        containerView.addSubview(destinationView!)
        // 目标控制器
        let destinationController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as? PhotoBrowseCollectionVC
        let indexPath = destinationController?.indexPaht
        // 当前跳转的控制器
        let collectionViewController = ((transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)) as! UINavigationController).topViewController as! ViewController
        let currentCollectionView = collectionViewController.collectionView
        // 当前选中的cell
        let selectctedCell = currentCollectionView?.cellForItem(at: indexPath! as IndexPath) as? DDCollectionCell
        // 新建一个imageview添加到目标view之上,做为动画view
        let annimateViwe = UIImageView()
        annimateViwe.image = selectctedCell?.imageView.image
        annimateViwe.contentMode = .scaleAspectFill
        annimateViwe.clipsToBounds = true
        // 被选中的cell到目标view上的座标转换
        let originFrame = currentCollectionView!.convert(selectctedCell!.frame, to: UIApplication.shared.keyWindow)
        annimateViwe.frame = originFrame
        containerView.addSubview(annimateViwe)
        let endFrame = coverImageFrameToFullScreenFrame(selectctedCell?.imageView.image)
        destinationView?.alpha = 0
        // 过渡动画执行
        UIView.animate(withDuration: 0.5, animations: {
            annimateViwe.frame = endFrame
        }, completion: { (finished) in
            transitionContext.completeTransition(true)
            UIView.animate(withDuration: 0.2, animations: {
                destinationView?.alpha = 1
            }, completion: { (_) in
                annimateViwe.removeFromSuperview()
            }) 
        }) 
    }
    
    func dismissViewAnimation(_ transitionContext: UIViewControllerContextTransitioning) {
        let transitionView = transitionContext.view(forKey: UITransitionContextViewKey.from)
        let contentView = transitionContext.containerView
        // 取出modal出的来控制器
        let destinationController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! UICollectionViewController
        // 取出当前显示的collectionview
        let presentView = destinationController.collectionView
        // 取出控制器当前显示的cell
        let dismissCell = presentView?.visibleCells.first as? CollectionViewCell
        // 新建过渡动画imageview
        let animateImageView = UIImageView()
        animateImageView.contentMode = .scaleAspectFill
        animateImageView.clipsToBounds = true
        // 获取当前显示的cell的image
        animateImageView.image = dismissCell?.imageView.image
        // 获取当前显示cell在window中的frame
        animateImageView.frame = (dismissCell?.imageView.frame)!
        contentView.addSubview(animateImageView)
        // 动画最后停止的frame
        let indexPath = presentView?.indexPath(for: dismissCell!)
        // 取出要返回的控制器view
        let originView = ((transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! UINavigationController).topViewController as! ViewController).collectionView
        
        var originCell = originView!.cellForItem(at: indexPath!)
        if originCell == nil {
            originView?.scrollToItem(at: indexPath!, at: .centeredVertically, animated: false)
            originView?.layoutIfNeeded()
        }
        originCell = originView!.cellForItem(at: indexPath!)
        let originFrame = originView?.convert(originCell!.frame, to: UIApplication.shared.keyWindow)
        UIView.animate(withDuration: 0.5, animations: {
            animateImageView.frame = originFrame!
            transitionView?.alpha = 0
        }, completion: { (_) in
            animateImageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }) 
    }
}
