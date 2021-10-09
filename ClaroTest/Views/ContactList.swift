//
//  ContactList.swift
//  ClaroTest
//
//  Created by Luis Santana on 5/10/21.
//

import SwiftUI
import CoreData


struct ContactList: View {
    
    
    @State var showDeleteButton: Bool = false
    @State var disableNavigation: Bool = false
    @State var search: String = ""
    @State var navigate: Bool = false
    let dataManager = PersistenceController.shared
    @ObservedObject var contactViewModel = ContactViewModel()
    @State var contacts = [SimpleContact]()
    @State private var refreshID = UUID()
    var body: some View {
        
            GeometryReader{ geo in
                VStack(alignment: .trailing){
                    
                    
                    List{
                        
                        HStack{
                            TextField("Search Contact", text: $search).padding()
                            Image(systemName: "magnifyingglass").foregroundColor(Color.red).padding()                        }.frame(width: geo.size.width/1.2, height: geo.size.height/10).onTapGesture {
                                self.searhWithFilter()
                            }
                        
                        ForEach(contacts, id: \.self){ contact in
                            
                            
                            HStack{
                                
                                if showDeleteButton{
                                    Button {
                                        print("hola \(contact.name ?? "")")
                                        self.contactViewModel.delete(contact: contact) { deleted in
                                            if deleted{
                                                DispatchQueue.main.async {
                                                    
                                                    withAnimation {
                                                        self.reloadData()
                                                        self.showDeleteButton.toggle()
                                                    }
                                                }
                                                
                                            }
                                        }
                                    } label: {
                                        Image(systemName: "minus.circle.fill").foregroundColor(Color.red)
                                    }

                                }
                                
                                HStack{
                                    
                    
                                        NavigationLink(isActive: self.$navigate) {
                                            EditContact(contact: contact, dataManager: self.contactViewModel.persistenceConreoller
                                            ).onDisappear(perform: {self.refreshID = UUID()})
                                        } label: {
                                            
                                            if contact.userPhoto !=  nil{
                                                HStack{
                                                Image(uiImage: UIImage(data: contact.userPhoto!)!).resizable().frame(width: 50, height: 50)
                                                VStack{
                                                    Text("\(contact.name ?? "Error!")")
                                                    Text("\(contact.phoneNumber ?? "Error!")")
                                                }

                                            }

                                            }

                                        }

                                    .isDetailLink(true)
                                    .disabled(self.disableNavigation)
                                }.padding(.leading, 20)
                            }

                        }
                    }.frame(width: geo.size.width, height: geo.size.height)
                        .id(refreshID)
                    
                }.frame(width: geo.size.width, height: geo.size.height)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .navigationTitle("Contacts")
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarItems(trailing: HStack{
                            
                            Button{
                                
                                withAnimation {
                                    self.reloadData()
                                }
                                
                            } label:{
                                Image(systemName: "arrow.triangle.2.circlepath.circle")
                            }
                            
                            NavigationLink {
                                AddContact()
                            } label: {
                                Text(Image(systemName: "plus"))
                            }
                            
                            Button {
                                self.showDeleteButton.toggle()
                                
                                self.disableNavigation.toggle()
                                print(self.disableNavigation)
                            } label: {
                                Image(systemName: "trash")
                            }
                        }).onAppear {
                            
                                self.disableNavigation = false
                                self.reloadData()
                            
                        }
            }
    }
    
    
    
    func reloadData(){
     
        DispatchQueue.main.async {
            self.contacts = self.dataManager.getContacts()
        }
    }
    
    func searhWithFilter(){
        if self.search != ""{
            DispatchQueue.main.async {
                self.contacts = self.dataManager.getContacts(search: self.search)
            }
            
        }else{
            DispatchQueue.main.async {
            self.contacts = self.dataManager.getContacts()
            }
        }
    }
}

struct ContactList_Previews: PreviewProvider {
    static var previews: some View {
        ContactList()
    }
}
