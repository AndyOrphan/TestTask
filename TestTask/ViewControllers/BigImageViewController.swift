//
//  BigImageViewController.swift
//  TestTask
//
//  Created by Orphan on 3/15/18.
//  Copyright © 2018 Orphan. All rights reserved.
//

import UIKit

class BigImageViewController: UIViewController {

    var selectedImage: UIImage?
    var selectedName: String?
    
    let imageView = UIImageView()
    let nameLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
        setupViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fillData() {
        imageView.backgroundColor = UIColor.groupTableViewBackground
        imageView.contentMode = .scaleAspectFit
        imageView.image = selectedImage ?? nil
        nameLabel.text = selectedName ?? "teeest"
    }
    
    //MARK: UI
    func setupViews() {
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(imageView)
        self.view.addSubview(nameLabel)
        nameLabel.textAlignment = .center
        
        setupConstarints()
    }
    
    func setupConstarints() {
        setupImageViewConstraints()
        setupLabelConstraints()
    }

    func setupImageViewConstraints() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(
            item: imageView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .topMargin,
            multiplier: 1,
            constant: 8).isActive = true
        
        NSLayoutConstraint(
            item: imageView,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .centerX,
            multiplier: 1,
            constant: 0).isActive = true
        
        NSLayoutConstraint(
            item: imageView,
            attribute: .width,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .width,
            multiplier: 0.9,
            constant: 0).isActive = true
        
        NSLayoutConstraint(
            item: imageView,
            attribute: .height,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .width,
            multiplier: 0.9,
            constant: 0).isActive = true
    }
    
    func setupLabelConstraints() {
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(
            item: nameLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: imageView,
            attribute: .bottom,
            multiplier: 1,
            constant: 16).isActive = true
        
        NSLayoutConstraint(
            item: nameLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .leading,
            multiplier: 1,
            constant: 16).isActive = true
        
        NSLayoutConstraint(
            item: nameLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .trailing,
            multiplier: 1,
            constant: -16).isActive = true
    }
    
}
