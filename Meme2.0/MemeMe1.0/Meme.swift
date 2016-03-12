//
//  Meme.swift
//  MemeMe1.0
//
//  Created by goldenlimit on 12/19/15.
//  Copyright © 2015 Yue Wu. All rights reserved.
//

import Foundation
import UIKit

class Meme {
    var topText: String!
    var bottomText: String!
    var image: UIImage!
    var memedImage: UIImage!


    init(topText:String, bottomText: String, image: UIImage, memedImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.image = image
        self.memedImage = memedImage
}

    func updateWith(topText: String, bottomText: String, memedImage: UIImage) {
        
        self.topText = topText
        self.bottomText = bottomText
        self.memedImage = memedImage
    }
}