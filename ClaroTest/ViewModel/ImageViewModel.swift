//
//  ImageViewModel.swift
//  ClaroTest
//
//  Created by Luis Santana on 6/10/21.
//

import Foundation
import UIKit

class ImageViewModel: ObservableObject{
    
    @Published var image: UIImage?
    @Published var imageLoaded: Bool = true
    
    var service = SearchImageService()
    
    
    func getImages(){
        
        service.getAllUrls{ [self] images, error in
            
            if let images = images{
                DispatchQueue.main.async {
                    self.imageLoaded = true
                    image = images
                }
                
            }
            
        }
        
    }
    
}
