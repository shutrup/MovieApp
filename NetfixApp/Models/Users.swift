//
//  Users.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 11.08.2022.
//

import Foundation
import FirebaseFirestore

struct Users: Hashable,Decodable {
    var username: String
    var email: String
    var avatarStringUrl: String
    var description: String
    var id : String
    
    init(username: String,email: String,avatarStringUrl: String,description: String,id : String){
        self.username = username
        self.email = email
        self.avatarStringUrl = avatarStringUrl
        self.description = description
        self.id = id
    }
    
    init?(document: DocumentSnapshot){
        guard let data = document.data() else {return nil}
        guard let username = data["username"] as? String,
        let email = data["email"] as? String,
        let id = data["uid"] as? String,
        let description = data["description"] as? String,
        let avatarStringUrl = data["avatarStringUrl"] as? String  else {return nil}
        
        self.username = username
        self.email = email
        self.id = id
        self.description = description
        self.avatarStringUrl = avatarStringUrl
        
    }
    
    var representation: [String:Any]{
        var rep = ["username": username]
        rep["email"] = email
        rep["avatarStringUrl"] = avatarStringUrl
        rep["description"] = description
        rep["uid"] = id
        
        return rep
    }
    
    func hash(into hasher: inout Hasher){
        hasher.combine(id)
    }
    
    static func == (lhs: Users,rhs: Users) -> Bool{
        return lhs.id == rhs.id
    }
}
