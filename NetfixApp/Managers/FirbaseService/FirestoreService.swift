//
//  FirestoreService.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 11.08.2022.
//

import Firebase
import FirebaseFirestore
import UIKit

class FirestoreService{
    
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("user")
    }
    
    func saveProfileWith(id: String, email: String, username: String, avatarImage: UIImage?, description: String, completion: @escaping (Result<Users,Error>) ->Void){
        guard Validators.isFilled(username: username, description: description) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        guard avatarImage != UIImage(named: "person") else {
            completion(.failure(UserError.photoNotExist))
            return
        }
        
        var user = Users(username: username, email: email, avatarStringUrl: "not exist", description: description, id: id)
        StorageService.shared.uploadPhoto(photo: avatarImage!) { result in
            switch result {
            case .success(let url):
                user.avatarStringUrl = url.absoluteString
                self.usersRef.document(user.id).setData(user.representation) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(user))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
                
    }
    
    func getUserData( user:User, completion: @escaping (Result<Users,Error>) ->Void){
        let docRef = usersRef.document(user.uid)
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                guard let users = Users(document: document) else {
                    completion(.failure(UserError.cannotUnwrapToUser))
                    return
                }
                completion(.success(users))
            } else {
                completion(.failure(UserError.cannotGetUserInfo))
            }
        }
    }
}
