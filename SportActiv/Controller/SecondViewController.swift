//
//  SecondViewController.swift
//  SportActiv
//
//  Created by Jan Moravek on 30/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit
import MMDrawerController

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let activityTable = UITableView()
    let switcher = UISegmentedControl(items: ["local","online","all"])
    let zeroLabel = UILabel()
    let fvc = FirstViewController()

    var activityType: Int = 0
    var empty: Bool = false
    
    var vcHeight:CGFloat = 0.0
    var vcWidth:CGFloat = 0.0
    var xHeight:CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        vcHeight = self.view.frame.height
        vcWidth = self.view.frame.width
        xHeight = vcWidth/12
        
        navigationItem.title = "sport activity records"

        configTable()
        configSegment()
        configBar()
        configZeroLabel()
        
        activityTable.delegate = self
        activityTable.dataSource = self
    }
    
    func configZeroLabel() {
        zeroLabel.frame = CGRect(x: 10, y: 2*vcHeight/50+xHeight+64, width: vcWidth-20, height: xHeight)
        zeroLabel.text = "No records"
        zeroLabel.font = UIFont(name: "System", size: 25)
        zeroLabel.textColor = UIColor.black
        zeroLabel.textAlignment = .center
        zeroLabel.numberOfLines = 1
        zeroLabel.isHidden = true
        self.view.addSubview(zeroLabel)
    }

    func configTable() {
        activityTable.frame = CGRect(x: 10 , y: 2*vcHeight/50+xHeight+64, width: vcWidth-20, height: vcHeight-xHeight-2*vcHeight/50-64-10)
        activityTable.register(CustomTableViewCell.self, forCellReuseIdentifier: "MyCell")
        activityTable.rowHeight = UITableViewAutomaticDimension
        activityTable.estimatedRowHeight = 44
        activityTable.separatorColor = UIColor.white
        activityTable.delegate = self
        activityTable.dataSource = self
        self.view.addSubview(activityTable)
    }

    func configSegment() {
        switcher.frame = CGRect(x: vcWidth/2 - 125 , y: vcHeight/50+64, width: 250, height: xHeight)
        switcher.selectedSegmentIndex = 0
        switcher.layer.cornerRadius = 5.0
        switcher.backgroundColor = UIColor.black
        switcher.layer.borderWidth = 1.0
        switcher.tintColor = UIColor.white
        switcher.addTarget(self, action:  #selector(self.switcher(_:)), for: .valueChanged)
        self.view.addSubview(switcher)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int?
        
        if activityType == 0 {
            number = MyVar.localActivityArray.count
        } else if activityType == 1 {
            number = MyVar.onlineActivityArray.count
        } else if activityType == 2 {
            number = MyVar.localActivityArray.count + MyVar.onlineActivityArray.count
        }
        
        if number == 0 {
            zeroLabel.isHidden = false
        }
        return number! 
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = activityTable.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath) as! CustomTableViewCell

        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        if activityType == 0 {
            cell.nameLabelCell.text = MyVar.localActivityArray[indexPath.row].name
            cell.locationLabelCell.text = MyVar.localActivityArray[indexPath.row].location
            cell.lengthLabelCell.text = String(MyVar.localActivityArray[indexPath.row].length)
            cell.backgroundColor = UIColor.red
            
        } else if activityType == 1 {
            cell.nameLabelCell.text = MyVar.onlineActivityArray[indexPath.row].name
            cell.locationLabelCell.text = MyVar.onlineActivityArray[indexPath.row].location
            cell.lengthLabelCell.text = String(MyVar.onlineActivityArray[indexPath.row].length)
            cell.backgroundColor = UIColor.blue
            
        } else if activityType == 2 {
            
            if indexPath.row <= MyVar.localActivityArray.count-1 {
                cell.nameLabelCell.text = MyVar.localActivityArray[indexPath.row].name
                cell.locationLabelCell.text = MyVar.localActivityArray[indexPath.row].location
                cell.lengthLabelCell.text = String(MyVar.localActivityArray[indexPath.row].length)
                cell.backgroundColor = UIColor.red
            } else {
                cell.nameLabelCell.text = MyVar.onlineActivityArray[indexPath.row-MyVar.localActivityArray.count].name
                cell.locationLabelCell.text = MyVar.onlineActivityArray[indexPath.row-MyVar.localActivityArray.count].location
                cell.lengthLabelCell.text = String(MyVar.onlineActivityArray[indexPath.row-MyVar.localActivityArray.count].length)
                cell.backgroundColor = UIColor.blue
            }
        }

        return cell
    }

    @objc func switcher(_ sender:UISegmentedControl) {
        zeroLabel.isHidden = true
        
        if sender.selectedSegmentIndex == 0 {
            activityType = sender.selectedSegmentIndex
            activityTable.reloadData()
        } else if sender.selectedSegmentIndex == 1 {
            activityType = sender.selectedSegmentIndex
            activityTable.reloadData()
        } else if sender.selectedSegmentIndex == 2 {
            activityType = sender.selectedSegmentIndex
            activityTable.reloadData()
        }
    }
    
    func configBar() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        let navItem = UIBarButtonItem(customView: button)

        self.navigationItem.setRightBarButtonItems([navItem], animated: true)
    }

    @objc func menuButtonPressed() {
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
    
    
}

