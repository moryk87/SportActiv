//
//  Firebase.swift
//  SportActiv
//
//  Created by Jan Moravek on 25/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import Foundation
import Firebase

protocol FirebaseDelegate {
    func saveAlert(didSave: Bool)
    func clearTextField(clearText: Bool)
}

class Firebase {
    
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
                self.delegate?.saveAlert(didSave: true)
                self.delegate?.clearTextField(clearText: true)
            }
        }
    }
    
    func retrieveOnline() {
        myDatabase = Database.database().reference().child("activityArray")
        
        myDatabase?.observe(.childAdded, with: { (snapshot) in
            
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            MyVar.onlineActivityArray.append(
                ActivityLabel(name: snapshotValue["name"]!, location: snapshotValue["location"]!, length: Float(snapshotValue["length"]!)!)
            )
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
