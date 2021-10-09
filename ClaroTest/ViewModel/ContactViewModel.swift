//
//  ContactViewModel.swift
//  ClaroTest
//
//  Created by Luis Santana on 8/10/21.
//

import Foundation
import SwiftUI


class ContactViewModel: ObservableObject{
    
    let persistenceConreoller = PersistenceController.shared
    var username: String = ""
    var userLastName: String = ""
    var userPhone: String = ""
    var userImage: UIImage?
    @Published var dataSaved: Bool = false
    
    func saveContact(completions: @escaping (Bool)-> () = {_ in}){
        
        let contact = SimpleContact(context: self.persistenceConreoller.container.viewContext)
        
        
        if self.username != "" || self.userLastName != "" || self.userPhone != "" || self.userImage != nil{
            contact.name = self.username
            contact.lastName = self.userLastName
            contact.phoneNumber = self.userPhone
            contact.userPhoto = self.userImage!.pngData()
            
            self.persistenceConreoller.save(self.persistenceConreoller.container.viewContext) { error in
                
                if error == nil{
                  
                    completions(true)
                }else{
                    completions(false)
                }
            }
            
            
        }
        
        
    }
    
   
    func delete(contact: SimpleContact, completions: @escaping (Bool) -> () = { _ in }) {
        
        self.persistenceConreoller.delete(object: contact) { deleted in
            
            if deleted{
                
                completions(true)
            }
            else{
                completions(false)
            }
        }
    }
    
}
