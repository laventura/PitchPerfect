//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Atul Acharya on 1/28/15.
//  Copyright (c) 2015 Atul Acharya. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    
    let filePathUrl: NSURL!
    let title: String!
    
    init (filePathUrl: NSURL, title: String) {
        self.filePathUrl    = filePathUrl
        self.title          = title
    }
    
}
