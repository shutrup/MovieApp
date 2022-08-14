//
//  StorageService.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 12.08.2022.
//

import Foundation
import FirebaseStorage
import FirebaseAuth
import UIKit

class StorageService {
    
    static let shared = StorageService()
    
    let storageRef = Storage.storage().reference()
    
    private var avatarsRef: StorageReference {
        return storageRef.child("avatars")
    }
    
    private var currentUserId: String {
        return Auth.auth().currentUser!.uid
    }
    
    func uploadPhoto(photo: UIImage,completion: @escaping (Result<URL,Error>) ->Void) {
        guard let scaledImage = photo.scaledTosafeUploadSize, let imageData = scaledImage.jpegData(compressionQuality: 0.4) else {
            
            return
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        avatarsRef.child(currentUserId).putData(imageData, metadata: metadata) { (metadata,error) in
            guard let _ = metadata else {
                completion(.failure(error!))
                return
            }
            self.avatarsRef.child(self.currentUserId).downloadURL { url, error in
                guard let downloadURL = url else {
                    completion(.failure(error!))
                    return
                }
                completion(.success(downloadURL))
            }
        }
        
    }
    
}
