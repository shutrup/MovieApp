//
//  DataPersistenceManager.swift
//  NetfixApp
//
//  Created by Шарап Бамматов on 04.08.2022.
//

import Foundation
import UIKit
import CoreData

enum DataBaseError: Error {
    case failedError
    case failedToFetchData
    case failedToDelete
}
class DataPersistenceManager {
    static let shared = DataPersistenceManager()
    
    func downloadTitleWith(model: Title, completion: @escaping (Result<Void,Error>) -> Void){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = Titleitem(context: context)
        
        item.id = Int64(model.id!)
        item.originalTitle = model.originalTitle
        item.originalName = model.originalName
        item.overview = model.overview
        item.mediaType = model.mediaType
        item.posterPath = model.posterPath
        item.releaseData = model.releaseDate
        item.voteCount = Int64(model.voteCount!)
        item.voteAverage = Double(model.voteAverage!)
        item.titleRu = model.titleRu
        item.name = model.name
        item.genreIDS = model.genreIDS
        
        do {
            try context.save()
            completion(.success(()))
        }
        catch {
            completion(.failure(DataBaseError.failedError ))
        }
    }
    
    func fetchingTitleFromDataBase(completion: @escaping (Result<[Titleitem],Error>)->Void ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<Titleitem>
        
        request = Titleitem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        }
        catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func deleteTitleWith(model: Titleitem, completion: @escaping (Result<Void,Error>) -> Void ) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        }
        catch {
            completion(.failure(DataBaseError.failedToDelete))
        }
    }
    
}
