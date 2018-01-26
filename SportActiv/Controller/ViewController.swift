//
//  ViewController.swift
//  SportActiv
//
//  Created by Jan Moravek on 24/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
//    var activity: ActivityLabel = ActivityLabel ()
    let firebase = Firebase ()
    
    var vHeight:CGFloat = 0.0
    var vWidth:CGFloat = 0.0
    var xHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vHeight = self.view.frame.height
        vWidth = self.view.frame.width
        xHeight = (vHeight-64)/12
        
        print(xHeight)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5/5S/5C/SE")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X")
            default:
                print("unknown")
            }
        }
        
        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: vWidth, height: 44))
        let navItem = UINavigationItem(title: "sport activity diary")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector))
//        navItem.rightBarButtonItem = doneItem
        navBar.setItems([navItem], animated: false)
        self.view.addSubview(navBar)
        
        nameLabel()
        nameTextField()
        locationLabel()
        locationTextField()
        lengthLabel()
        lengthTextField()
        localButton()
        onlineButton()
        
        firebase.logIn()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - labels/textFields/buttons
    /***************************************************************/
    
    func nameLabel() {
        let nameLabel = UILabel(frame: CGRect(x: vWidth/2 - 150, y: 1*xHeight+44, width: 300, height: xHeight))
        nameLabel.text = "name of the sport activity:"
        nameLabel.font = UIFont(name: "System", size: 25)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
//        nameLabel.layer.borderWidth = 1.0
        self.view.addSubview(nameLabel)
    }
    
    func nameTextField() {
        let nameTextField = UITextField(frame: CGRect(x: vWidth/2 - 125, y: 2*xHeight+44, width: 250, height: xHeight))
        nameTextField.placeholder = "Enter name of the activity"
        nameTextField.font = UIFont(name: "System", size: 12)
        nameTextField.borderStyle = UITextBorderStyle.roundedRect
        nameTextField.autocorrectionType = UITextAutocorrectionType.no
        nameTextField.keyboardType = UIKeyboardType.alphabet
        nameTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        nameTextField.addTarget(self, action: #selector(nameTextFieldValueChanged(_:)), for: .editingChanged)
        
        nameTextField.delegate = self
        self.view.addSubview(nameTextField)
    }
    
    func locationLabel() {
        let locationLabel = UILabel(frame: CGRect(x: vWidth/2 - 150, y: 4*xHeight+44, width: 300, height: xHeight))
        locationLabel.text = "location of the sport activity:"
        locationLabel.font = UIFont(name: "System", size: 25)
        locationLabel.textColor = UIColor.black
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 1
        self.view.addSubview(locationLabel)
    }
    
    func locationTextField() {
        let locationTextField = UITextField(frame: CGRect(x: vWidth/2 - 125, y: 5*xHeight+44, width: 250, height: xHeight))
        locationTextField.placeholder = "Enter location of the activity"
        locationTextField.font = UIFont(name: "System", size: 12)
        locationTextField.borderStyle = UITextBorderStyle.roundedRect
        locationTextField.autocorrectionType = UITextAutocorrectionType.no
        locationTextField.keyboardType = UIKeyboardType.alphabet
        locationTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        locationTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        locationTextField.addTarget(self, action: #selector(locationTextFieldValueChanged(_:)), for: .editingChanged)
        
        locationTextField.delegate = self
        self.view.addSubview(locationTextField)
    }
    
    func lengthLabel() {
        let lengthLabel = UILabel(frame: CGRect(x: vWidth/2 - 150, y: 7*xHeight+44, width: 300, height: xHeight))
        lengthLabel.text = "length of the sport activity:"
        lengthLabel.font = UIFont(name: "System", size: 25)
        lengthLabel.textColor = UIColor.black
        lengthLabel.textAlignment = .center
        lengthLabel.numberOfLines = 1
        self.view.addSubview(lengthLabel)
    }
    
    func lengthTextField() {
        let lengthTextField = UITextField(frame: CGRect(x: vWidth/2 - 125, y: 8*xHeight+44, width: 250, height: xHeight))
        lengthTextField.placeholder = "Enter length of the activity"
        lengthTextField.font = UIFont(name: "System", size: 10)
        lengthTextField.borderStyle = UITextBorderStyle.roundedRect
        lengthTextField.autocorrectionType = UITextAutocorrectionType.no
        lengthTextField.keyboardType = UIKeyboardType.decimalPad
        lengthTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
        lengthTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        
        lengthTextField.addTarget(self, action: #selector(lengthTextFieldValueChanged(_:)), for: .editingChanged)
        
        lengthTextField.delegate = self
        self.view.addSubview(lengthTextField)
    }
    
    
    func localButton() {
        let localButton: UIButton = UIButton(frame: CGRect(x: vWidth/2 - 120, y: 10*xHeight+44, width: 100, height: xHeight))
        localButton.backgroundColor = UIColor.black
        localButton.setTitle("Save Localy", for: .normal)
        localButton.titleLabel?.font = UIFont(name: "System", size: 15)
        localButton.addTarget(self, action:#selector(self.localButtonPressed), for: .touchUpInside)
        self.view.addSubview(localButton)
    }
    
    func onlineButton() {
        let onlineButton: UIButton = UIButton(frame: CGRect(x: vWidth/2 + 20, y: 10*xHeight+44, width: 100, height: xHeight))
        onlineButton.backgroundColor = UIColor.black
        onlineButton.setTitle("Save Online", for: .normal)
        onlineButton.titleLabel?.font = UIFont(name: "System", size: 15)
        onlineButton.addTarget(self, action:#selector(self.onlineButtonPressed), for: .touchUpInside)
        self.view.addSubview(onlineButton)
    }
    
    @objc func localButtonPressed() {
        print("Local Button Clicked")
        
    }
    
    @objc func onlineButtonPressed() {
        print("OnLine Button Clicked")
        firebase.uploadActivity ()
    }

    //MARK: - Firebase managing
    /***************************************************************/
    
    
    
    
    //MARK: - TextFieldValueChanged
    /***************************************************************/

    @objc func nameTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.activity.name = sender.text!
            print(sender.text!)
        }
    }
    
    @objc func locationTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.activity.location = sender.text!
            print(sender.text!)
        }
    }
    
    @objc func lengthTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.activity.length = Float(sender.text!)!
            print(sender.text!)
        }
    }

    
        
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
//            self.view.setNeedsDisplay()
//            super.view.layoutSubviews()
            self.view.contentMode = .redraw
//            self.view.setNeedsLayout()
        } else {
            print("Portrait")
//            self.view.setNeedsLayout()
//            self.view.setNeedsDisplay()
            self.view.contentMode = .redraw
//            super.view.layoutSubviews()
        }
    }
    
    
//    let myFirstLabel = UILabel()
//    let myFirstButton = UIButton()
//    myFirstLabel.text = "I made a label on the screen #toogood4you"
//    myFirstLabel.font = UIFont(name: "MarkerFelt-Thin", size: 45)
//    myFirstLabel.textColor = UIColor.redColor()
//    myFirstLabel.textAlignment = .Center
//    myFirstLabel.numberOfLines = 5
//    myFirstLabel.frame = CGRectMake(15, 54, 300, 500)
    
//    myFirstButton.setTitle("✸", forState: .Normal)
//    myFirstButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
//    myFirstButton.frame = CGRectMake(15, -50, 300, 500)
//    myFirstButton.addTarget(self, action: #selector(myClass.pressed(_:)), forControlEvents: .TouchUpInside)
//    self.view.addSubview(myFirstLabel)
//    self.view.addSubview(myFirstButton)
//
//
//    @objc func pressed(sender: UIButton!) {
//        var alertView = UIAlertView()
//        alertView.addButton(withTitle: "Ok")
//        alertView.title = "title"
//        alertView.message = "message"
//        alertView.show()
//    }
    
    
    
    
    

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.setNavigationBar()
//    }
    
//    func setNavigationBar() {
//        let screenSize: CGRect = UIScreen.main.bounds
//        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
//        let navItem = UINavigationItem(title: "")
//        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(done))
//        navItem.rightBarButtonItem = doneItem
//        navBar.setItems([navItem], animated: false)
//        self.view.addSubview(navBar)
//    }
//
//    @objc func done() { // remove @objc for Swift 3
//
//    }
    
}


//MARK: - UITextFieldDelegate
/***************************************************************/

extension ViewController  {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // return NO to disallow editing.
        print("TextField should begin editing method called")
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // became first responder
        print("TextField did begin editing method called")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
        print("TextField should snd editing method called")
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
        print("TextField did end editing method called")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        // if implemented, called in place of textFieldDidEndEditing:
        print("TextField did end editing with reason method called")
        print(MyVar.activity.name)
        print(MyVar.activity.location)
        print(MyVar.activity.length)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // return NO to not change text
        print("While entering the characters this method gets called")
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // called when clear button pressed. return NO to ignore (no notifications)
        print("TextField should clear method called")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // called when 'return' key pressed. return NO to ignore.
        print("TextField should return method called")
        textField.resignFirstResponder()
        return true
    }
    
}


//func textField(nameField: String) {
//    
//    let genericTextField = UITextField ()
//    genericTextField.placeholder = "Enter length here"
//    genericTextField.font = UIFont(name: "System", size: 15)
//    genericTextField.borderStyle = UITextBorderStyle.roundedRect
//    genericTextField.autocorrectionType = UITextAutocorrectionType.no
//    genericTextField.keyboardType = UIKeyboardType.default
//    genericTextField.returnKeyType = UIReturnKeyType.done
//    genericTextField.clearButtonMode = UITextFieldViewMode.whileEditing;
//    genericTextField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
//    
//    if nameField == "nameTextField" {
//        let nameTextField = genericTextField
//        //            let nameTextField = UITextField ()
//        nameTextField.frame = CGRect(x: vWidth/2 - 125, y: 2*xHeight+44, width: 250, height: xHeight)
//        nameTextField.addTarget(self, action: #selector(nameTextFieldValueChanged(_:)), for: .editingChanged)
//        nameTextField.delegate = self
//    } else if nameField == "locationTextField" {
//        let locationTextField = genericTextField
//        //            let locationTextField = UITextField ()
//        locationTextField.frame = CGRect(x: vWidth/2 - 125, y: 5*xHeight+44, width: 250, height: xHeight)
//        locationTextField.addTarget(self, action: #selector(locationTextFieldValueChanged(_:)), for: .editingChanged)
//        locationTextField.delegate = self
//    } else if nameField == "lengthTextField" {
//        //            let lengthTextField = UITextField ()
//        let lengthTextField = genericTextField
//        lengthTextField.frame = CGRect(x: vWidth/2 - 125, y: 8*xHeight+44, width: 250, height: xHeight)
//        lengthTextField.addTarget(self, action: #selector(lengthTextFieldValueChanged(_:)), for: .editingChanged)
//        lengthTextField.delegate = self
//        self.view.addSubview(lengthTextField)
//    }
//}
//
