//
//  MainViewController.swift
//  TestTask
//
//  Created by Orphan on 3/15/18.
//  Copyright © 2018 Orphan. All rights reserved.
//

import UIKit
import RealmSwift

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    let mainTableView = UITableView()
    var realm: Realm!
    
    var imageModels:Results<ImageModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        realm = try! Realm()
        imageModels = realm.objects(ImageModel.self).sorted(byKeyPath: "date", ascending: false)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObservers()
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
        setupSearchTextField()
    }
    
    func setupSearchTextField() {
        let screenWidth = UIScreen.main.bounds.width
        let searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: screenWidth * 0.7, height: 40))
        searchTextField.placeholder = "search"
        searchTextField.borderStyle = .roundedRect
        searchTextField.backgroundColor = UIColor.white
        self.navigationItem.titleView = searchTextField
        
        searchTextField.delegate = self
        
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
        return imageModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let imageModel = imageModels[indexPath.row]
        let cell = UITableViewCell()
        cell.textLabel?.text = imageModel.searchWord
        cell.imageView?.image = UIImage(data: imageModel.downloadedImage)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bigImageVC = BigImageViewController()
        let imageModel = imageModels[indexPath.row]
        bigImageVC.selectedImage = UIImage(data: imageModel.downloadedImage)
        bigImageVC.selectedName = imageModel.searchWord
        self.navigationController?.pushViewController(bigImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    //MARK: Server methods
    
    func searchImage(with query: String) {
        ServerManager.shared.searchImage(with: query, callback: { name, imageData in
            
            let imageModel = ImageModel()
            imageModel.downloadedImage = imageData
            imageModel.searchWord = name
            imageModel.date = Date()
            self.saveImage(with: imageModel)
            
        })
    }
    
    func saveImage(with model: ImageModel) {
        try! realm.write {
            realm.add(model)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.mainTableView.reloadData()
            })
        }
    }
    
    //MARK: SearchField Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let searchText = textField.text {
            if searchText.count > 0 {
                searchImage(with: searchText)
            }
        }
        textField.resignFirstResponder()
        textField.text = ""
        
        return true
    }

    //MARK: Observers
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(showPopup), name: NSNotification.Name(rawValue: Consts.errorNotificationName), object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Consts.errorNotificationName), object: nil)
    }
    
    //MARK: Popups
    
    @objc func showPopup(_ notification: Notification) {
        if let errorStr = notification.userInfo?["errorStr"] as? String {
            let alertController = UIAlertController(title: "Error", message: errorStr, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alertController.dismiss(animated: true, completion: nil)
                })
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
