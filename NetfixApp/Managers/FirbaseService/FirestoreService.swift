//
//  FirestoreService.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 11.08.2022.
//

import Firebase
import FirebaseFirestore

class FirestoreService{
    
    static let shared = FirestoreService()
    let db = Firestore.firestore()
    
    private var usersRef: CollectionReference {
        return db.collection("users")
    }
    
    func saveProfileWith(id: String, email: String, username: String, avatarImageString: String, description: String, completion: @escaping (Result<Users,Error>) ->Void){
        guard Validators.isFilled(username: username, description: description) else {
            completion(.failure(UserError.notFilled))
            return
        }
        
        let user = Users(username: username, email: email, avatarStringUrl: "", description: description, id: id)
        
        self.usersRef.document(user.id).setData(user.representation) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(user))
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
