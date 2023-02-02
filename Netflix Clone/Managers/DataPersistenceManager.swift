//
//  DataPersistenceManager.swift
//  Netflix Clone
//
//  Created by Ali Görkem Aksöz on 2.02.2023.
//

import UIKit
import CoreData

class DataPersistenceManager {
    
    enum DatabaseError: Error {
        case FailedToSaveData
    }
    static let shared = DataPersistenceManager()
    private init() { }
    
    func downloadTitle(with model: Title, completion: @escaping (Result<Void, Error>) -> ()) {
            
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TitleItem(context: context)
        
        item.id = Int64(model.id!)
        item.original_name = model.original_name
        item.overview = model.overview
        item.media_type = model.media_types
        item.poster_path = model.poster_path
        item.release_data = model.release_date
        item.vote_count = Int64(model.vote_count!)
        item.vote_average = model.vote_average!
        item.orignal_title = model.original_title
        
        do {
            try context.save()
            completion(.success(()))
        } catch  {
            completion(.failure(DatabaseError.FailedToSaveData))
        }
        
    }
    
    func fetchingTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> ()  ) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        do {
            let titles = try context.fetch(request)
            completion(.success(titles))
        } catch  {
            print(error.localizedDescription)
        }
    }
    
    func deleteTitle(with model: TitleItem, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do {
            try context.save()
            completion(.success(()))
        } catch  {
            print(error.localizedDescription)
        }
    }
}

