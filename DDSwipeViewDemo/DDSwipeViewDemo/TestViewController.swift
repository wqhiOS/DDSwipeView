//
//  TestViewController.swift
//  DDSwipeViewDemo
//
//  Created by wuqh on 2018/7/16.
//  Copyright © 2018年 wuqh. All rights reserved.
//

import UIKit

class TestViewController: UIViewController,UITableViewDataSource {
    
    lazy var tableView: UITableView = {
        let tv = UITableView(frame: self.view.bounds, style: .plain)
        tv.dataSource = self
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

}
