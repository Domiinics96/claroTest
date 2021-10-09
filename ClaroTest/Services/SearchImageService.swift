//
//  SearchImageService.swift
//  ClaroTest
//
//  Created by Luis Santana on 6/10/21.
//

import Foundation
import UIKit


class SearchImageService{
    
    let url: String = "https://serpapi.com/search.json?engine=google&q=animal&api_key=2583add77eb7ac177662812ddf45166dc3fc5d8d68df7241dd0f91fa6be481b1"
    func getAllUrls(completions: @escaping (UIImage?, String?) -> () = {_ ,_  in}){
        
        guard let url = URL(string: url) else {
            
            completions(nil, "404")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            
            if let _ = error{
                
                completions(nil, "")
            }
            
            if let httpresponse = response as? HTTPURLResponse {
                
                if httpresponse.statusCode == 200{
                    
                    if let finalData = data{
                        do{
                            
                            let data2 = try JSONDecoder().decode(TopStories.self, from: finalData)
                            
                            if let all = data2.inline_images{
                                var allUrls = [String]()
                                for url2 in all {
                                    if let finalUrl = url2.thumbnail{
                                        
                                    allUrls.append(finalUrl)
                                        
                                    }
                                }
                                let uri = allUrls.randomElement()
                                 
                                 if let ur = uri{
                                     self.getImages(urls: ur) { ima, error in
                                         
                                         if let finalImage = ima{
                                             DispatchQueue.main.async {
                                                 completions(finalImage, "Done")
                                             }
                                         }
                                     }
                                 }
                            }
                        }catch{
                            completions(nil, "error")
                        }
                    }
                }
            }else{

                completions(nil, "Response error")
            }
    
        }.resume()
    
    }
    
    func getImages(urls: String, completions: @escaping (UIImage?, String?) -> () = {_,_  in}) {
        
       
            guard let url = URL(string: urls) else {
                completions(nil, "url error")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error{
                    completions(nil, "error: \(error)")
                
                }
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        
                        if let finalData = data{
                            
                            let image = UIImage(data: finalData)
                            if let ima = image{
                                    completions(ima, "Done")
                            }
          
                        }
                        
                    }
                }
                
                
            }.resume()
        
        }
   
}

