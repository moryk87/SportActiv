//
//  Firebase.swift
//  SportActiv
//
//  Created by Jan Moravek on 25/01/2018.
//  Copyright © 2018 Jan Moravek. All rights reserved.
//

import Foundation
import Firebase

class Firebase {
    
    var myDatabase: DatabaseReference?
    
    func uploadActivity () {
        
        myDatabase = Database.database().reference()
        
        let activityToSend = ["name": MyVar.activity.name,
                              "location": MyVar.activity.location,
                              "length": String(MyVar.activity.length)]
        
        myDatabase?.child("activityArray").childByAutoId().setValue(activityToSend) {
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("saved successfully")
            }
        }
    }
    
    func logIn () {
        
        Auth.auth().signInAnonymously { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("login succesful")
            }
        }
    }
    
}
