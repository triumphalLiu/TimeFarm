//
//  ChooseCityTableViewController.swift
//  TimeFarm
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 liu. All rights reserved.
//

import UIKit
class ChooseCityTableViewController:UITableViewController{
    
    @IBOutlet var CityTableView: UITableView!
    
    var webs:NSArray?
    
    private func addCitiesToTableView() {
        webs = NSArray(objects: "hangge.com","baidu.com","google.com","163.com","qq.com")
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "cell0")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return webs!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as UITableViewCell
        let url = webs![indexPath.row] as! String
        cell.textLabel?.text = url
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCitiesToTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
