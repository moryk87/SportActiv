//
//  FirstViewController.swift
//  SportActiv
//
//  Created by Jan Moravek on 24/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import UIKit
import CoreData
import MMDrawerController

class FirstViewController: UIViewController, UITextFieldDelegate, FirebaseDelegate {

    let firebase = Firebase()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var vcHeight:CGFloat = 0.0
    var vcWidth:CGFloat = 0.0
    var xHeight:CGFloat = 0.0
    
    let nameTextField = UITextField()
    let locationTextField = UITextField()
    let lengthTextField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        vcHeight = self.view.frame.height
        vcWidth = self.view.frame.width
        xHeight = (vcHeight-64)/12
        
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
        
//        let navBar: UINavigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: vcWidth, height: 44))
//        let navItem = UINavigationItem(title: "sport activity diary")
        //        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(getter: UIAccessibilityCustomAction.selector))
        //
        //        navItem.rightBarButtonItem = doneItem
        //        navBar.barTintColor = UIColor.black
        //        navBar.setItems([navItem], animated: false)
        //        self.view.addSubview(navBar)
        
//        let navItem = UINavigationItem(title: "sport activity diary")
//        self.navigationItem.setItems([navItem], animated: false)
        
//        navigationBar.topItem.title = "some title"
        
        
        
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu"), for: .normal)
//        let button = UIButton(type: .system)
//        button.setTitle("MENU", for: .normal)
//        button.tintColor = UIColor.black
//        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        let navItem = UIBarButtonItem(customView: button)

        self.navigationItem.setRightBarButtonItems([navItem], animated: true)
        self.navigationItem.title = "sport activity diary"
//        self.navigationItem.
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        configNameLabel()
        configNameTextField()
        configLocationLabel()
        configLocationTextField()
        configLengthLabel()
        configLengthTextField()
        configLocalButton()
        configOnlineButton()
        
        retrieveLocaly()
        
        firebase.logIn()
        firebase.retrieveOnline()
        firebase.delegate = self
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
    //MARK: - labels/textFields/buttons
    /***************************************************************/
    
    func configNameLabel() {
        let nameLabel = UILabel(frame: CGRect(x: vcWidth/2 - 150, y: 1*xHeight+44, width: 300, height: xHeight))
        nameLabel.text = "name of the sport activity:"
        nameLabel.font = UIFont(name: "System", size: 25)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
//        nameLabel.layer.borderWidth = 1.0
        self.view.addSubview(nameLabel)
    }
    
    func configNameTextField() {
        nameTextField.frame = CGRect(x: vcWidth/2 - 125, y: 2*xHeight+44, width: 250, height: xHeight)
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
    
    func configLocationLabel() {
        let locationLabel = UILabel(frame: CGRect(x: vcWidth/2 - 150, y: 4*xHeight+44, width: 300, height: xHeight))
        locationLabel.text = "location of the sport activity:"
        locationLabel.font = UIFont(name: "System", size: 25)
        locationLabel.textColor = UIColor.black
        locationLabel.textAlignment = .center
        locationLabel.numberOfLines = 1
        self.view.addSubview(locationLabel)
    }
    
    func configLocationTextField() {
        locationTextField.frame = CGRect(x: vcWidth/2 - 125, y: 5*xHeight+44, width: 250, height: xHeight)
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
    
    func configLengthLabel() {
        let lengthLabel = UILabel(frame: CGRect(x: vcWidth/2 - 150, y: 7*xHeight+44, width: 300, height: xHeight))
        lengthLabel.text = "length of the sport activity:"
        lengthLabel.font = UIFont(name: "System", size: 25)
        lengthLabel.textColor = UIColor.black
        lengthLabel.textAlignment = .center
        lengthLabel.numberOfLines = 1
        self.view.addSubview(lengthLabel)
    }
    
    func configLengthTextField() {
        lengthTextField.frame = CGRect(x: vcWidth/2 - 125, y: 8*xHeight+44, width: 250, height: xHeight)
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
    
    
    func configLocalButton() {
        let localButton: UIButton = UIButton(frame: CGRect(x: vcWidth/2 - 120, y: 10*xHeight+44, width: 100, height: xHeight))
        localButton.backgroundColor = UIColor.black
        localButton.setTitle("Save Localy", for: .normal)
        localButton.titleLabel?.font = UIFont(name: "System", size: 15)
        localButton.addTarget(self, action:#selector(self.localButtonPressed), for: .touchUpInside)
        self.view.addSubview(localButton)
    }
    
    func configOnlineButton() {
        let onlineButton: UIButton = UIButton(frame: CGRect(x: vcWidth/2 + 20, y: 10*xHeight+44, width: 100, height: xHeight))
        onlineButton.backgroundColor = UIColor.black
        onlineButton.setTitle("Save Online", for: .normal)
        onlineButton.titleLabel?.font = UIFont(name: "System", size: 15)
        onlineButton.addTarget(self, action:#selector(self.onlineButtonPressed), for: .touchUpInside)
        self.view.addSubview(onlineButton)
    }
    
    @objc func localButtonPressed() {
        saveLocaly()
    }
    
    @objc func onlineButtonPressed() {
        firebase.saveOnline()
    }

    
    
    //MARK: -
    /***************************************************************/
    
    func saveLocaly() {
//        let activity = Activity(name: MyVar.name, location: MyVar.location, length: MyVar.length)
        let activity = Activity(context: context)

        activity.name = MyVar.name
        activity.location = MyVar.location
        activity.length = MyVar.length
        
        do {
            try context.save()
            saveAlert(didSave: true)
            clearTextField(clearText: true)
            print("saveLocaly")
        } catch {
            print("Error saving content::: \(error)")
        }
    }
    
    
    func retrieveLocaly () {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        do {
            MyVar.localActivityArray = try context.fetch(request)
            print("fetch data")
        } catch {
            print("Error fetching data from context::: \(error)")
        }
    }
    
//    func deleteA() {
//        context.delete(MyVar.localActivityArray[indexPath.row])
//        MyVar.localActivityArray.remove(at: indexPath.row)
//    }
    
   
    func saveAlert(didSave: Bool) {
    
        let blurEffect = UIBlurEffect(style: .light)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        self.view.addSubview(blurVisualEffectView)
        
        let saveAlert = UIAlertController(title: "Saved", message: "Activity saved successfully", preferredStyle: UIAlertControllerStyle.alert)
        
        saveAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in blurVisualEffectView.removeFromSuperview()
        }))
        
        present(saveAlert, animated: true, completion: nil)
    }
    
    @objc func menuButtonPressed() {
        print("pressed")
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
    
    func clearTextField(clearText: Bool) {
        nameTextField.text = ""
        locationTextField.text = ""
        lengthTextField.text = ""
        print("clear")
    }
    
    
    //MARK: -
    /***************************************************************/
    
//    func saveActivity() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let activity = Activity(context: context) // Link Task & Context
//        activity.name = MyVar.activity.name
////        activity.l
////        activity.name
//        
//        // Save the data to coredata
//        (UIApplication.shared.delegate as! AppDelegate).saveContext()
//        
////        let _ = navigationController?.popViewController(animated: true)
//    }
    
   
    //MARK: - TextFieldValueChanged
    /***************************************************************/

    @objc func nameTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.name = sender.text!
            print(sender.text!)
        }
    }
    
    @objc func locationTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.location = sender.text!
            print(sender.text!)
        }
    }
    
    @objc func lengthTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.length = Float(sender.text!)!
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

extension FirstViewController  {
    
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
        print(MyVar.name)
        print(MyVar.location)
        print(MyVar.length)
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
//        nameTextField.frame = CGRect(x: vcWidth/2 - 125, y: 2*xHeight+44, width: 250, height: xHeight)
//        nameTextField.addTarget(self, action: #selector(nameTextFieldValueChanged(_:)), for: .editingChanged)
//        nameTextField.delegate = self
//    } else if nameField == "locationTextField" {
//        let locationTextField = genericTextField
//        //            let locationTextField = UITextField ()
//        locationTextField.frame = CGRect(x: vcWidth/2 - 125, y: 5*xHeight+44, width: 250, height: xHeight)
//        locationTextField.addTarget(self, action: #selector(locationTextFieldValueChanged(_:)), for: .editingChanged)
//        locationTextField.delegate = self
//    } else if nameField == "lengthTextField" {
//        //            let lengthTextField = UITextField ()
//        let lengthTextField = genericTextField
//        lengthTextField.frame = CGRect(x: vcWidth/2 - 125, y: 8*xHeight+44, width: 250, height: xHeight)
//        lengthTextField.addTarget(self, action: #selector(lengthTextFieldValueChanged(_:)), for: .editingChanged)
//        lengthTextField.delegate = self
//        self.view.addSubview(lengthTextField)
//    }
//}
//
