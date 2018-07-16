//
//  DDSwipeTableView.swift
//  DDSwipeViewDemo
//
//  Created by wuqh on 2018/7/16.
//  Copyright © 2018年 wuqh. All rights reserved.
//
import UIKit
import SnapKit

protocol DDSwipeTableViewDelegate: NSObjectProtocol {
    func swipeTableViewContainerCanScroll(_ swipeTableView: DDSwipeTableView)
    func swipeTableViewContentCanScroll(_ swipeTableView: DDSwipeTableView)
    func swipeTableViewDidScroll(_ scrollView: UIScrollView)
}

class DDSwipeTableView: UITableView {
    
    weak var swipeDelegate: DDSwipeTableViewDelegate?
    
    var segmentViewHeight: CGFloat = 0
    var headerHeight: CGFloat = 0
    
    var _canScroll: Bool = true
    var canScroll: Bool {
        set {
            if _canScroll == newValue {
                return
            }
            _canScroll = newValue
            if _canScroll == true {
                swipeDelegate?.swipeTableViewContentCanScroll(self)
            }
        }
        get {
            return _canScroll
        }
    }
    
    var headerView: UIView? {
        didSet {
            tableHeaderView = headerView
        }
    }
    
    var segmentView: UIView? {
        didSet {
            segmentViewHeight = segmentView?.bounds.height ?? 0
            reloadData()
        }
    }
    
    var contentView: DDSwipeContentView?
    
    var allowGetsturEventPassViews = [UIView]()
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        panGestureRecognizer.cancelsTouchesInView = false
        
        backgroundColor = UIColor.green
        
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UITableViewDataSource,UITableViewDelegate
extension DDSwipeTableView: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.contentView.addSubview(contentView!)
        //        cell.backgroundColor = UIColor.yellow
        contentView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bounds.size.height - segmentViewHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return segmentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return segmentViewHeight
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        var topOffset:CGFloat = 0
        if let supView = self.superview as? DDSwipeView {
            topOffset = (supView.delegate?.swipeViewTopOffset?()) ?? 0
        }
        let contentOffset: CGFloat = (headerView?.bounds.height)! - topOffset
        
        if canScroll == false {
            scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
        } else if scrollView.contentOffset.y >= contentOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: contentOffset)
            canScroll = false
            if let swipeDelegate = swipeDelegate {
                swipeDelegate.swipeTableViewContentCanScroll(self)
            }
        }
        swipeDelegate?.swipeTableViewDidScroll(scrollView)
        
    }
}

// MARK: - UIGestureRecognizerDelegate
extension DDSwipeTableView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let view = otherGestureRecognizer.view {
            if allowGetsturEventPassViews.contains(view) {
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
}
