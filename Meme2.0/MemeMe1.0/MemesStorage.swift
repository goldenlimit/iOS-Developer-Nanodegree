//
//  MemesStorage.swift
//  MemeMe
//
//  Created by Max Sokolov on 27/06/15.
//  Copyright (c) 2015 Max Sokolov. All rights reserved.
//

import Foundation

/*!
    MemesStorage singleton. Safely manages all memes.
*/
class MemesStorage {

    static let defaultStorage = MemesStorage()
    private var memes = Array<Meme>()
    
    func saveMeme(meme: Meme) {

        memes.append(meme)
    }
    
    func numberOfMemes() -> Int {

        return memes.count
    }

    func memeAtIndex(index: Int) -> Meme? {

        if index < memes.count {
            return memes[index]
        }
        return nil
    }
    
    func deleteMemeAtIndex(index: Int) {

        if index < memes.count {
            memes.removeAtIndex(index)
        }
    }
}