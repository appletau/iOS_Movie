//
//  SubjectModel.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Subject: MovieSubject {
    let id:String
    let title:String
    let original_title:String
    let rating:Rating?
    let images:Dictionary<String,URL>
    let directors:Array<Celebrity>
    let casts:Array<Celebrity>
    let pubdates:Array<String>
    let year:String
    let durations:Array<String>
    let genres:Array<String>
    
    //Detailed info
    let countries:Array<String>
    let summary:String
    let photos:[Photo]
    let popular_comments:[Comment]
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = values.contains(.id) ? try values.decode(String.self, forKey: .id) : ""
        self.title = values.contains(.title) ? try values.decode(String.self, forKey: .title) : ""
        self.original_title = values.contains(.original_title) ? try values.decode(String.self, forKey: .original_title) : ""
        self.rating = values.contains(.rating) ? try values.decode(Rating?.self, forKey: .rating) : nil
        self.images = values.contains(.images) ? try values.decode(Dictionary<String,URL>.self, forKey: .images) : [:]
        self.directors = values.contains(.directors) ? try values.decode(Array<Celebrity>.self, forKey: .directors) : []
        self.casts = values.contains(.casts) ? try values.decode(Array<Celebrity>.self, forKey: .casts) : []
        self.pubdates = values.contains(.pubdates) ? try values.decode(Array<String>.self, forKey: .pubdates) : []
        self.year = values.contains(.year) ? try values.decode(String.self, forKey: .year) : ""
        self.durations = values.contains(.durations) ? try values.decode(Array<String>.self, forKey: .durations) : []
        self.genres = values.contains(.genres) ? try values.decode(Array<String>.self, forKey: .genres) : []
        self.countries = values.contains(.countries) ? try values.decode(Array<String>.self, forKey: .countries) : []
        self.summary = values.contains(.summary) ? try values.decode(String.self, forKey: .summary) : ""
        self.photos = values.contains(.photos) ? try values.decode(Array<Photo>.self, forKey: .photos) : []
        self.popular_comments = values.contains(.popular_comments) ? try values.decode(Array<Comment>.self, forKey: .popular_comments) : []
    }
}


