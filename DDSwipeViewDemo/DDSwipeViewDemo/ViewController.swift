//
//  ViewController.swift
//  DDSwipeViewDemo
//
//  Created by wuqh on 2018/7/16.
//  Copyright © 2018年 wuqh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var headerView: UIView = {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 150))
        headerView.backgroundColor = UIColor.red
        return headerView
    }()
    private lazy var segmentView: UIView = {
        let segmentView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 48))
        segmentView.backgroundColor = UIColor.yellow
        return segmentView
    }()
    private lazy var swipeView: DDSwipeView = {
        let swipeView = DDSwipeView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: self.view.bounds.size.height - 64), segmentHeight: 48)
        swipeView.headerView = headerView
        swipeView.segmentView = segmentView
        swipeView.dataSource = self
        return swipeView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(swipeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
extension ViewController: DDSwipeViewDataSource {
    func numberOfPagesInContentView(_ contentView: UICollectionView) -> Int {
        return 5
    }
    
    func swipeContentView(_ contentView: UICollectionView, pageForIndex: Int) -> UIScrollView {
        let vc = TestViewController()
        addChildViewController(vc)
        return vc.tableView
    }
    
    
}

