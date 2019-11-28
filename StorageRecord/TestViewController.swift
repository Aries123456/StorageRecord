//
//  TestViewController.swift
//  StorageRecord
//
//  Created by likun on 2019/11/28.
//  Copyright © 2019 lk. All rights reserved.
//

import UIKit
import Masonry

class TestViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    lazy var dataArray = NSMutableArray()
    var tableView : UITableView!
    var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addUI();
        self.addData();
    }
    
    func getCurrentTimes() -> NSString {
        //获取当前的时间
        let formatter = DateFormatter();
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let datenow = NSDate();
        let currentTimeString = NSString(format: "%@", formatter.string(from: datenow as Date));
        return currentTimeString;
    }
    
    func addData() {
        let array = UserDefaults.standard.value(forKey: "data") as? NSArray;
        if (array != nil) && array!.count > 0 {
            self.dataArray.addObjects(from: array as! [Any]);
            self.tableView.reloadData();
        }
    }
    
    func addUI() {
        self.tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height), style: .plain);
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView(frame: .zero);
        self.view.addSubview(self.tableView);
        
        self.button = UIButton(type: .custom);
        self.button.backgroundColor = UIColor.yellow;
        self.button.setTitle("记录", for: .normal);
        self.button.setTitleColor(UIColor.red, for: .normal);
        self.button.titleLabel?.font = UIFont.systemFont(ofSize: 18);
        self.button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside);
        self.view.addSubview(self.button);
        
        self.tableView.mas_makeConstraints { (make) in
            make?.top.left().right().mas_equalTo()(0);
            make?.bottom.mas_equalTo()(-100);
        }
        
        self.button.mas_makeConstraints { (make) in
            make?.left.bottom().right().mas_equalTo()(0);
            make?.top.equalTo()(self.tableView.mas_bottom);
        }
    }
    
    @objc func buttonAction(sender:UIButton) {
        let array = UserDefaults.standard.value(forKey: "data") as? NSArray;
        if (array != nil) && array!.count > 0 {
            self.dataArray.removeAllObjects();
            self.dataArray.addObjects(from: array as! [Any]);
        }
        self.dataArray.add(getCurrentTimes());
        UserDefaults.standard.set(self.dataArray.copy(), forKey: "data");
        UserDefaults.standard.synchronize();
        self.tableView.reloadData();
        self.scrollTableToFoot(animated: true);
    }
    
    //滑到最底部
    func scrollTableToFoot(animated:Bool) {
        let s = self.tableView.numberOfSections;
        if (s < 1) {
            return;
        }
        
        let r = self.tableView.numberOfRows(inSection: s-1);
        if (r < 1) {
            return;
        }
        
        let ip = NSIndexPath.init(row: r-1, section: s-1);
        self.tableView.scrollToRow(at: ip as IndexPath, at: .bottom, animated: animated);
    }
        
    //代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView .dequeueReusableCell(withIdentifier: "CELLID");
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "CELLID");
        }
        
        cell?.textLabel?.text = self.dataArray[indexPath.row] as? String;
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle != .delete) {
            return ;
        }
        self.dataArray.removeObject(at: indexPath.row);
        let array = UserDefaults.standard.value(forKey: "data") as? NSArray;
        if (array != nil) && array!.count > 0 {
            UserDefaults.standard.removeObject(forKey: "data");
            UserDefaults.standard.synchronize();
        }
        UserDefaults.standard.set(self.dataArray.copy(), forKey: "data");
        UserDefaults.standard.synchronize();
        self.tableView.deleteRows(at: [indexPath], with: .bottom);
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete;
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除";
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
