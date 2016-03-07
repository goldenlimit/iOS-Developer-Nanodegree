//
//  MemeGenerator.swift
//  MemeMe
//
//  Created by Max Sokolov on 27/06/15.
//  Copyright (c) 2015 Max Sokolov. All rights reserved.
//

import Foundation
import UIKit

class MemeGenerator {

    class func generateImageFromView(view: UIView) -> UIImage {

        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return memedImage
    }
}