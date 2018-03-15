//
//  MainViewController.swift
//  TestTask
//
//  Created by Orphan on 3/15/18.
//  Copyright © 2018 Orphan. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let mainTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        ServerManager.shared.testConnection()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UI
    
    func setupViews() {
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(mainTableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        mainTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(
            item: mainTableView,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .trailing,
            multiplier: 1,
            constant: 0).isActive = true
        
        NSLayoutConstraint(
            item: mainTableView,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .leading,
            multiplier: 1,
            constant: 0).isActive = true
        
        NSLayoutConstraint(
            item: mainTableView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .top,
            multiplier: 1,
            constant: 0).isActive = true
        
        NSLayoutConstraint(
            item: mainTableView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .bottom,
            multiplier: 1,
            constant: 0).isActive = true
        
    }
    
    //MARK: TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "test"
        cell.imageView?.image = nil
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bigImageVC = BigImageViewController()
        self.navigationController?.pushViewController(bigImageVC, animated: true)
    }

}
