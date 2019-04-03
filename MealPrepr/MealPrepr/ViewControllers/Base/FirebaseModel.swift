//
//  FirebaseModel.swift
//  MealPrepr
//
//  Created by Andrew Daniels on 4/1/19.
//  Copyright © 2019 Andrew Daniels. All rights reserved.
//

import FirebaseDatabase
import FirebaseStorage

class FirebaseModel {
    
    func getModelForId<T: IFirebaseModel>(id: String, completionHandler: @escaping (_ isResponse : T) -> Void) {
        
        guard let s = self as? IFirebaseModel, let p = s.path else { return }
        
        let path = "\(p)/\(id)"
        
        FirebaseModel.references().dbRef.child(path).observeSingleEvent(of: .value) { (snapshot) in
            
            guard let value = snapshot.value else { return }
            
            do {
                if JSONSerialization.isValidJSONObject(value) {
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: jsonData)
                
                    completionHandler(result)
                }
            } catch {
                print("There was an error retrieving Codable Object with Id: \(id). \(error)")
            }
        }
        
    }
    
    static func get<T: IFirebaseModel>(completionHandler: @escaping (_ isResponse : [T]) -> Void) {
        
        guard let s = self as? IFirebaseModel, let p = s.path else { return }
        
        references().dbRef.child(p).observeSingleEvent(of: .value) { (snapshot) in
            guard let value = snapshot.value else { return }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [])
                let result = try JSONDecoder().decode([T].self, from: jsonData)
                
                completionHandler(result)
            } catch {
                print("There was an error retrieving Array of Codable Objects.")
            }
        }
    }
    
    func save(completionHandler: @escaping (_ isResponse : Bool) -> Void) {
        
        guard let s = self as? IFirebaseModel, let p = s.path else { return }
        
        var referenceKey: String!
        if let id = s.id {
            referenceKey = id
        } else {
            referenceKey = FirebaseModel.references().dbRef.child(p).childByAutoId().key
        }
        
        if let key = referenceKey {
            let updates = [
                p + "\(key)": s.updateData
            ]
            
            FirebaseModel.references().dbRef.updateChildValues(updates)
            completionHandler(true)
        }
        
    }
    
    static func references() -> (dbRef: DatabaseReference, storRef: StorageReference) {
        let dbRef: DatabaseReference = Database.database().reference()
        let storRef: StorageReference = Storage.storage().reference()
        
        return(dbRef: dbRef, storRef: storRef)
    }
    
}

protocol IFirebaseModel: Codable {
    var id: String! { get set }
    var path: String! { get set }
    var updateData: [String: Any] { get }
    
    func populate(completionHandler: @escaping (_ isResponse : Bool) -> Void)
}
