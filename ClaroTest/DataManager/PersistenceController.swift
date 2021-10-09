//
//  PersistenceController.swift
//  ClaroTest
//
//  Created by Luis Santana on 8/10/21.
//

import Foundation
import CoreData

struct PersistenceController{
    
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Contact")
        container.loadPersistentStores { description, error in
            
            if let error = error{
                
                fatalError(" error  \(error.localizedDescription)")
            }
            
        }
    }
    
    
    func save(_ contact: NSManagedObjectContext? ,completion: @escaping (Error?) -> () = { _ in}) {
     
            
            do{
                try contact!.save()
                print("Category saved")
                completion(nil)
            }catch{
                completion(error)
            }
        
   
    }
    
    func getContacts(search: String = "") -> [SimpleContact] {
        
        let allContacts: NSFetchRequest<SimpleContact> = SimpleContact.fetchRequest()
        if search != ""{
            let predicate = NSPredicate(format: "name = %@", search)
            allContacts.predicate = predicate
        }
        
        
        
        do{
            return try self.container.viewContext.fetch(allContacts)
        }catch{
            
            return []
        }
        
    }
    
    func delete(object: SimpleContact, completion: @escaping (Bool) -> ()) {
        
        self.container.viewContext.delete(object)
        
        do{
           try self.container.viewContext.save()
            completion(true)
            
        }catch{
            
            self.container.viewContext.rollback()
            completion(false)
            
        }
  
    }
    
    func updateContact(completion: @escaping (Bool) -> ()){
        do{
           try self.container.viewContext.save()
            completion(true)
            
        }catch{
            
            self.container.viewContext.rollback()
            completion(false)
            
        }
    }
    

}
