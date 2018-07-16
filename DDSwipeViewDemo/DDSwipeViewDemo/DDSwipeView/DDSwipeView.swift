//
//  DDSwipeView.swift
//  DDSwipeViewDemo
//
//  Created by wuqh on 2018/7/16.
//  Copyright © 2018年 wuqh. All rights reserved.
//

import UIKit

import UIKit

public protocol DDSwipeViewDataSource {
    func numberOfPagesInContentView(_ contentView: UICollectionView) -> Int
    func swipeContentView(_ contentView: UICollectionView, pageForIndex: Int) -> UIScrollView
}
@objc public protocol DDSwipeViewDelegate {
    @objc optional func swipeViewTopOffset() -> CGFloat
    @objc optional func swipeContentViewDidScroll(_ collectionView: UICollectionView)
    @objc optional func swipeContentViewDidEndDecelerating(_ collectionView: UICollectionView)
    @objc optional func swipeContentViewWillBeginDragging(_ collectionView: UICollectionView)
    @objc optional func swipeViewDidScroll(_ scrollView: UIScrollView)
}

/*
 使用方法：
 使用初始化方法：init(frame: CGRect,segmentHeight: CGFloat)，要传入segmentHeight，headerView设置好frame就能自动识别到高度，但是segmentHeight需要传入
 设置dataSource，实现DDSwipeViewDataSource
 设置segmentView headerView.
 完成
 */
public class DDSwipeView: UIView {
    
    public var dataSource: DDSwipeViewDataSource?
    public var delegate: DDSwipeViewDelegate?
    
    public var segmentView: UIView? {
        didSet {
            mainView.segmentView = segmentView
        }
    }
    
    public var headerView: UIView? {
        didSet {
            mainView.headerView = headerView
        }
    }
    
    private var canContentScroll: Bool = false
    private var viewList = [UIScrollView]()
    
    private var segmentHeight: CGFloat = 0
    private var headerHeight: CGFloat = 0
    
    private lazy var mainView: DDSwipeTableView = {
        let mainView = DDSwipeTableView(frame: bounds, style: .plain)
        mainView.swipeDelegate = self
        return mainView
    }()
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bounds.size.height-segmentHeight-0.5)
        
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    private lazy var contentView: DDSwipeContentView = {
        let contentView = DDSwipeContentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-segmentHeight), collectionViewLayout: flowLayout)
        contentView.swipeContentViewDataSource = self
        contentView.swipeContentViewDelegate = self
        return contentView
    }()
    
    public convenience init(frame: CGRect,segmentHeight: CGFloat) {
        self.init(frame: frame)
        self.segmentHeight = segmentHeight
        addSubview(mainView)
        mainView.contentView = contentView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let scrollView = object as! UIScrollView
        if canContentScroll == false {
            
            scrollView.removeObserver(self, forKeyPath: "contentOffset")
            scrollView.contentOffset = CGPoint.zero
            scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        }else if scrollView.contentOffset.y <= 0 {
            canContentScroll = false
            mainView.canScroll = true
        }
    }
}

extension DDSwipeView: DDSwipeTableViewDelegate {
    func swipeTableViewContainerCanScroll(_ swipeTableView: DDSwipeTableView) {
        for scrollView in viewList {
            scrollView.contentOffset = CGPoint.zero
        }
    }
    func swipeTableViewContentCanScroll(_ swipeTableView: DDSwipeTableView) {
        canContentScroll = true
    }
    func swipeTableViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.swipeViewDidScroll?(scrollView)
    }
}

extension DDSwipeView: DDSwipeContentViewDataSource,DDSwipeContentViewDelegate {
    
    func numberOfPagesInContentView(_ contentView: DDSwipeContentView) -> Int {
        return dataSource?.numberOfPagesInContentView(contentView) ?? 0
    }
    
    func swipeContentView(_ contentView: DDSwipeContentView, pageForIndex: Int) -> UIScrollView {
        
        let scrollView = (dataSource?.swipeContentView(contentView, pageForIndex: pageForIndex))!
        mainView.allowGetsturEventPassViews.append(scrollView)
        viewList.append(scrollView)
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
        return viewList[pageForIndex]
        
    }
    
    func swipeContentViewDidScroll(_ collectionView: DDSwipeContentView) {
        self.delegate?.swipeContentViewDidScroll?(collectionView)
    }
    func swipeContentViewDidEndDecelerating(_ collectionView: DDSwipeContentView) {
        self.delegate?.swipeContentViewDidEndDecelerating?(collectionView)
    }
    func swipeContentViewWillBeginDragging(_ collectionView: DDSwipeContentView) {
        self.delegate?.swipeContentViewWillBeginDragging?(collectionView)
    }
}

