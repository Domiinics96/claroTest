//
//  AddContact.swift
//  ClaroTest
//
//  Created by Luis Santana on 6/10/21.
//

import SwiftUI

struct AddContact: View {
    
    @ObservedObject var contactViewModel = ContactViewModel()
    @ObservedObject var image = ImageViewModel()
//    @State var userName: String = ""
//    @State var userLastName: String = ""
//    @State var userPhone: String = ""
    @State var isNewContact: Bool = true
    @State var isEmptyForm: Bool = false
    @Environment (\.presentationMode) var presentation
    var contact: String = ""
   
    var body: some View {
        
        
        GeometryReader{ geo in
        VStack{
            
            Spacer(minLength: 100)
            
            VStack{
                

               
                Image(uiImage: self.image.image == nil ? UIImage(systemName: "person")! : self.image.image!)
                        .resizable().frame(width: geo.size.width/2, height: geo.size.height/3.5, alignment: .center)
                
                Button {
                    self.image.imageLoaded = false
                    self.image.getImages()
                        
                    
                } label: {
                    Text("Load Image")
                }.frame(width: geo.size.width/2.5, height: 50).background(Color.white).cornerRadius(30)
                    
                
              
            }.frame(width: geo.size.width, height: geo.size.height/3).overlay(ProgressView("Loading Image").foregroundColor(Color.red).opacity(image.imageLoaded ? 0: 1).progressViewStyle(CircularProgressViewStyle(tint: Color.red)).frame(width:175, height: 175).offset(x: 0, y: -geo.size.height/20))
            Spacer(minLength: 20)
            
            VStack(spacing: 0){
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    
                    Text("User name").padding(20)
                    
                    TextField("", text: self.$contactViewModel.username).padding(.horizontal, 20).font(Font.custom("Arial", size: 20)).keyboardType(.alphabet).offset(x: 0, y: -geo.size.height/50)
                    
                }.background(Color.white)
                VStack(alignment: HorizontalAlignment.leading) {
                    
                    Text("Last Name").padding(20)
                    
                    TextField("", text: self.$contactViewModel.userLastName).padding(.horizontal, 20).font(Font.custom("Arial", size: 20)).keyboardType(.alphabet).offset(x: 0, y: -geo.size.height/40)
                    
                }.background(Color.white).padding(.vertical, 1)
                VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                    
                    Text("Phone number").padding(20)
                    
                    TextField("", text: self.$contactViewModel.userPhone).padding(.horizontal, 20).font(Font.custom("Arial", size: 20)).keyboardType(.alphabet).offset(x: 0, y: -geo.size.height/50)
                    
                }.background(Color.white)
            }
            
            Spacer(minLength: 100)
            
                

                VStack{
                    Button {


                        if self.contactViewModel.username == "" || self.contactViewModel.userPhone == "" || self.contactViewModel.userLastName == "" || self.image.image == nil{
                            self.isEmptyForm = true

                        }else{
                            self.contactViewModel.userImage = self.image.image
                            contactViewModel.saveContact { isSaved in

                                if isSaved{
                                    self.contactViewModel.username = ""
                                    self.contactViewModel.userLastName = ""
                                    self.contactViewModel.userPhone = ""
                                    self.contactViewModel.userImage = nil
                                    self.presentation.wrappedValue.dismiss()
                                }

                            }
                        }

                    } label: {
                        Text("Save")
                    }.frame(width: geo.size.width/1.2, height: geo.size.height/12).background(Color.gray).cornerRadius(10)

                }

                
              
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
            .navigationTitle("New contact")
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
            .alert(isPresented: $isEmptyForm) {
                Alert(title: Text("Empty Form"), message: Text("Fill all fields "), dismissButton: .default(Text("ok"), action: {
                    self.isEmptyForm = false
                }))
            }
       
        }.ignoresSafeArea(SafeAreaRegions.container,edges: .bottom)
    }
}


struct AddContact_Previews: PreviewProvider {
    static var previews: some View {
        AddContact()
    }
}
