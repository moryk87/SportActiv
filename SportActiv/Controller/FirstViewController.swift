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
       
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "menu"), for: .normal)
        button.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        let navItem = UIBarButtonItem(customView: button)

        self.navigationItem.setRightBarButtonItems([navItem], animated: true)
        self.navigationItem.title = "sport activity diary"
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        MyVar.onlineActivityArray.removeAll()
    }
    
    
    //MARK: - labels/textFields/buttons
    /***************************************************************/
    
    func configNameLabel() {
        let nameLabel = UILabel(frame: CGRect(x: vcWidth/2 - 150, y: 1*xHeight+44, width: 300, height: xHeight))
        nameLabel.text = "name of the sport activity:"
        nameLabel.font = UIFont(name: "System", size: 25)
        nameLabel.textColor = UIColor.black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 1
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

    
    //MARK: - save/retrieveLocaly
    /***************************************************************/
    
    func saveLocaly() {
        let activity = Activity(context: context)

        activity.name = MyVar.name
        activity.location = MyVar.location
        activity.length = MyVar.length
        
        do {
            try context.save()
            saveAlert(didSave: true)
            clearTextField(clearText: true)
            retrieveLocaly()
        } catch {
            print("Error saving content::: \(error)")
        }
    }
    
    func retrieveLocaly () {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        
        do {
            MyVar.localActivityArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context::: \(error)")
        }
    }
    
    
    //MARK: - saveAlert / menuButtonPressed / clearTextField
    /***************************************************************/

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
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.centerContainer?.toggle(MMDrawerSide.right, animated: true, completion: nil)
    }
    
    func clearTextField(clearText: Bool) {
        nameTextField.text = ""
        locationTextField.text = ""
        lengthTextField.text = ""
    }
    
   
    //MARK: - TextFieldValueChanged
    /***************************************************************/

    @objc func nameTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.name = sender.text!
        }
    }
    
    @objc func locationTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.location = sender.text!
        }
    }
    
    @objc func lengthTextFieldValueChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty
        {
            MyVar.length = Float(sender.text!)!
        }
    }

    
}
