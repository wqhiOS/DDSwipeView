//
//  DDSwipeContentView.swift
//  DDSwipeViewDemo
//
//  Created by wuqh on 2018/7/16.
//  Copyright © 2018年 wuqh. All rights reserved.
//

import UIKit

protocol DDSwipeContentViewDataSource: NSObjectProtocol {
    func numberOfPagesInContentView(_ contentView: DDSwipeContentView) -> Int
    func swipeContentView(_ contentView: DDSwipeContentView, pageForIndex: Int) -> UIScrollView
}
protocol DDSwipeContentViewDelegate: NSObjectProtocol {
    
    func swipeContentViewDidScroll(_ collectionView: DDSwipeContentView)
    func swipeContentViewDidEndDecelerating(_ collectionView: DDSwipeContentView)
    func swipeContentViewWillBeginDragging(_ collectionView: DDSwipeContentView)
}


class DDSwipeContentView: UICollectionView {
    
    weak var swipeContentViewDataSource: DDSwipeContentViewDataSource?
    weak var swipeContentViewDelegate: DDSwipeContentViewDelegate?
    
    private let cellId = "DDSwipeContentViewCellId"
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        isPagingEnabled = true
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DDSwipeContentView: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let swipeContentViewDataSource = swipeContentViewDataSource {
            
            return swipeContentViewDataSource.numberOfPagesInContentView(self)
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        if let swipeContentViewDataSource = swipeContentViewDataSource {
            let pageView = swipeContentViewDataSource.swipeContentView(self, pageForIndex: indexPath.item)
            
            for subView in cell.subviews {
                subView.removeFromSuperview()
            }
            cell.addSubview(pageView)
            pageView.snp.makeConstraints { (make) in
                make.left.right.top.bottom.equalToSuperview()
            }
            
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        swipeContentViewDelegate?.swipeContentViewDidScroll(scrollView as! DDSwipeContentView)
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        swipeContentViewDelegate?.swipeContentViewDidEndDecelerating(scrollView as! DDSwipeContentView)
        
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        swipeContentViewDelegate?.swipeContentViewWillBeginDragging(scrollView as! DDSwipeContentView)
    }
}
