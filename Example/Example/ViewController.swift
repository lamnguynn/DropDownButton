//
//  ViewController.swift
//  Example
//
//  Created by Lam Nguyen on 8/14/21.
//

import UIKit
import DropDownButton

class ViewController: UIViewController {
    
    let dataSource: [String] = ["Apples", "Oranges", "Bananas"]
    let dropDownButton: DropDownButton? = DropDownButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.view.addSubview(dropDownButton!)
        //Set up the drop down button
        dropDownButton?.dataSource = self.dataSource
        dropDownButton?.setTitle("Select a food", for: .normal)
        dropDownButton?.backgroundColor = .systemIndigo
        
        dropDownButton!.dropDownTextSize = 16
        dropDownButton!.heightOfDropDown = 200
        dropDownButton?.dataSource = self.dataSource
        dropDownButton?.dropDownColor = .systemIndigo
        dropDownButton?.dropDownTextColor = .lightGray
        dropDownButton?.dropDownCornerRadius = 25
        
        dropDownButton?.translatesAutoresizingMaskIntoConstraints = false
        dropDownButton?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        dropDownButton?.heightAnchor.constraint(equalToConstant: 45).isActive = true
        dropDownButton?.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        dropDownButton?.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }


}

