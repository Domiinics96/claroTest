//
//  ContentView.swift
//  ClaroTest
//
//  Created by Luis Santana on 5/10/21.
//

import SwiftUI

struct ContentView: View, Equatable {
    var body: some View {
        NavigationView{
            
            GeometryReader{ geo in
                
                
                VStack{
                    
                    Spacer()
                   

                    Image("ClaroLogo")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding()
                    NavigationLink("Go to test!", destination: ContactList())
                        .frame(width: 200, height: 75, alignment: .center)
                        .background(Color.blue)
                        .foregroundColor(.red)
                        .cornerRadius(20)
                        .font(Font.custom("Montserrat-Bold", size: 40.0))
                    
                    Spacer()
                    Spacer()
                }.frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
