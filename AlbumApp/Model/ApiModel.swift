//
//  ApiModel.swift
//  AlbumApp
//
//  Created by Ashish Patel on 27/09/19.
//  Copyright © 2019 Ashish Patel. All rights reserved.
//

import Foundation
import UIKit

class Album: Codable
{
    var artistName: String?
    var name: String?
    var artworkUrl100: String?
    var releaseDate: String?
    var copyright: String?
    var genres: [GenreList]?
    var url: String?
}

class GenreList: Codable
{
    var genreId: String?
    var name: String?
    var url: String?
}

extension Array where Element == GenreList {
    
     func getCommaSeparatedValues() -> String {
        
        var value = ""
        for genre in self {
            if let name = genre.name {
                if value.isEmpty {
                    value = name
                } else {
                    value = value + ", \(name)"
                }
            }
        }
        
        return value
    }
}
