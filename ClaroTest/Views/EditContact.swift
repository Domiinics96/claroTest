//
//  EditContact.swift
//  ClaroTest
//
//  Created by Luis Santana on 8/10/21.
//

import SwiftUI

struct EditContact: View {
    
    
    let contact: SimpleContact?
    let dataManager: PersistenceController
    @ObservedObject var image = ImageViewModel()
    @State var userName: String = ""
    @State var userLastName: String = ""
    @State var userPhone: String = ""
    @State var userImage: UIImage?
    @State var changeImage: Bool = false
    @Environment (\.presentationMode) var presentation
    @State var isEmptyForm: Bool = false
    

    var body: some View {
    
        GeometryReader{ geo in
            VStack{
                
                Spacer(minLength: 100)
                
                VStack{
                    
                  
                    if self.contact?.userPhoto != nil && self.image.image == nil{
                        Image(uiImage: UIImage(data: self.contact!.userPhoto!)!)
                                .resizable()
                                .frame(width: geo.size.width/2, height: geo.size.height/3.5, alignment: .center)
                    }else if self.image.image != nil{
                        
                        Image(uiImage: self.image.image == nil ? UIImage(systemName: "person")! : self.image.image!)
                                .resizable()
                                .frame(width: geo.size.width/2, height: geo.size.height/3.5, alignment: .center)
                    }
                    
                
                    
                    Button {
                        DispatchQueue.main.async {
                            self.userImage = nil
                            self.image.getImages()
                        }
                        
                        
                    } label: {
                        Text("Load Image")
                    }.frame(width: geo.size.width/2.5, height: 50).background(Color.white).cornerRadius(30)
                        
                    
                  
                }.frame(width: geo.size.width, height: geo.size.height/3).overlay(ProgressView("Loading Image").foregroundColor(Color.red).opacity(self.image.imageLoaded ? 0: 1).progressViewStyle(CircularProgressViewStyle(tint: Color.red)).frame(width:175, height: 175).offset(x: 0, y: -geo.size.height/20))
                Spacer(minLength: 20)
                
                VStack(spacing: 0){
                    VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                        
                        Text("UserName").padding(20)
                        
                        TextField("", text: self.$userName).padding(.horizontal, 20).font(Font.custom("Arial", size: 20)).keyboardType(.alphabet).offset(x: 0, y: -geo.size.height/50)
                        
                    }.background(Color.white)
                    VStack(alignment: HorizontalAlignment.leading) {
                        
                        Text("Last Name").padding(20)
                        
                        TextField("", text: self.$userLastName).padding(.horizontal, 20).font(Font.custom("Arial", size: 20)).keyboardType(.alphabet).offset(x: 0, y: -geo.size.height/40)
                        
                    }.background(Color.white).padding(.vertical, 1)
                    VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                        
                        Text("Phone number").padding(20)
                        
                        TextField("", text: self.$userPhone).padding(.horizontal, 20).font(Font.custom("Arial", size: 20)).keyboardType(.alphabet).offset(x: 0, y: -geo.size.height/50)
                        
                    }.background(Color.white)
                }
                
                Spacer(minLength: 100)
                
 
                Button {
                    self.contact!.name = self.userName
                    self.contact!.lastName = self.userLastName
                    self.contact!.phoneNumber = self.userPhone
                    
                    if self.image.image != nil{
                        self.contact!.userPhoto = self.image.image!.pngData()
                    }
                    
                    
                    self.dataManager.updateContact { isUpdated in
                        
                        DispatchQueue.main.async {
                            if isUpdated{
                                self.userName = ""
                                self.userLastName = ""
                                self.userPhone = ""
                                self.userImage = nil
                                self.presentation.wrappedValue.dismiss()
                            }else{
                                print("error")
                            }
                        }
                        
                        
                    }
                } label: {
                    Text("Save")
                }.frame(width: geo.size.width/1.2, height: geo.size.height/12).background(Color.gray).cornerRadius(10)

                  
                Spacer()
         
            }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                .background(Color.gray.opacity(0.5))
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading:
                                        
                    Button {
                    
                    self.presentation.wrappedValue.dismiss()
                    
                } label: {
                    
                    Text("Cancel")
                })
                .navigationBarItems(trailing:
                                        
                    Button {
                    
                   
                    
                } label: {
                    
                    Text("Edit")
                }.opacity( 1)
                .disabled(false))
                .navigationTitle("Contact")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(StackNavigationViewStyle())
                .alert(isPresented: $isEmptyForm) {
                    Alert(title: Text("Empty Form"), message: Text("Fill all fields "), dismissButton: .default(Text("ok"), action: {
                        self.isEmptyForm = false
                    }))
                }.onAppear {
                        DispatchQueue.main.async { [self] in
                            if self.contact!.name != nil{
                                self.userName = self.contact!.name!
                                self.userPhone = self.contact!.phoneNumber!
                                self.userLastName = self.contact!.lastName!
                                self.userImage = UIImage(data: self.contact!.userPhoto!)!
                    
                            }
                        }
                }
           
            }.ignoresSafeArea(SafeAreaRegions.container,edges: .bottom)
        }
        
}


struct EditContact_Previews: PreviewProvider {
    static var previews: some View {
        
        let dataManager = PersistenceController()
        let contact = SimpleContact(context: dataManager.container.viewContext)
        EditContact(contact: contact, dataManager: dataManager)
    }
}
