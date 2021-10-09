//
//  Images.swift
//  ClaroTest
//
//  Created by Luis Santana on 6/10/21.
//

import Foundation
import UIKit
import SwiftUI


struct TopStories: Decodable{

    var inline_images: [Images]?

}

struct Images: Decodable{
    
    var thumbnail: String?
    
    
}
