//
//  Firebase.swift
//  SportActiv
//
//  Created by Jan Moravek on 25/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol FirebaseDelegate {
    func saveAlert(didSave: Bool)
    func clearTextField(clearText: Bool)
}

class Firebase {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var myDatabase: DatabaseReference?
    var delegate: FirebaseDelegate?
    
    func saveOnline() {
        myDatabase = Database.database().reference()
        
        let activityToSend = ["name": MyVar.name,
                              "location": MyVar.location,
                              "length": String(MyVar.length)]
        
        myDatabase?.child("activityArray").childByAutoId().setValue(activityToSend) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("saved successfully")
                self.delegate?.saveAlert(didSave: true)
                self.delegate?.clearTextField(clearText: true)
            }
        }
    }
    
    func retrieveOnline() {
        myDatabase = Database.database().reference().child("activityArray")
        
        myDatabase?.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
//            MyVar.onlineActivityArray.append(
//                Activity(name: snapshotValue["name"]!, location: snapshotValue["location"]!, length: Float(snapshotValue["length"]!)!)
//            )
            
            let activity = Activity(context: self.context)
            
            activity.name = snapshotValue["name"]!
            activity.location = snapshotValue["location"]!
            activity.length = Float(snapshotValue["length"]!)!
            
            MyVar.onlineActivityArray.append(activity)
            
            print(snapshot.key)
        })
    }
    
    func logIn() {
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("login succesful")
            }
        }
    }
    
}
