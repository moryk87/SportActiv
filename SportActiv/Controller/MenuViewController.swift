//
//  MenuViewController.swift
//  SportActiv
//
//  Created by Jan Moravek on 01/02/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit
import MMDrawerController

class MenuViewController: UIViewController {

    let fvc = FirstViewController()
    var xHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "menu"
        
        xHeight = (self.view.frame.height-64)/12
        
        confiFirstViewButton()
        configSecondViewButton()
    }
    
    func confiFirstViewButton() {
        let firstViewButton: UIButton = UIButton(frame: CGRect(x: 10, y: 1*xHeight+44, width: 110, height: xHeight))
        firstViewButton.backgroundColor = UIColor.black
        firstViewButton.setTitle("FirstView", for: .normal)
        firstViewButton.titleLabel?.font = UIFont(name: "System", size: 15)
        firstViewButton.addTarget(self, action:#selector(self.firstViewButtonPressed), for: .touchUpInside)
        self.view.addSubview(firstViewButton)
    }
    
    func configSecondViewButton() {
        let secondViewButton: UIButton = UIButton(frame: CGRect(x: 10, y: 2*xHeight+54, width: 110, height: xHeight))
        secondViewButton.backgroundColor = UIColor.black
        secondViewButton.setTitle("SecondView", for: .normal)
        secondViewButton.titleLabel?.font = UIFont(name: "System", size: 15)
        secondViewButton.addTarget(self, action:#selector(self.secondViewButtonPressed), for: .touchUpInside)
        self.view.addSubview(secondViewButton)
    }

    @objc func firstViewButtonPressed() {
        
        let firstVC = FirstViewController(nibName: nil, bundle: nil)
        let firstNC = UINavigationController(rootViewController: firstVC)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer?.centerViewController = firstNC
        appDelegate.centerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
    
    @objc func secondViewButtonPressed() {
        
        let secondVC = SecondViewController(nibName: nil, bundle: nil)
        let secondNC = UINavigationController(rootViewController: secondVC)
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.centerContainer?.centerViewController = secondNC
        appDelegate.centerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }


}
