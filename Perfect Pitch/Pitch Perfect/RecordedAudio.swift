//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Yue Wu on 10/22/15.
//  Copyright © 2015 Yue Wu. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject {
    
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL!, title:String!){
        self.filePathUrl = filePathUrl
        self.title = title
    }
    
}