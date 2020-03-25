//
//  Model.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/24.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct User:Codable {
    var login:String
    var avatar_url:URL
    var site_admin:Bool
    var name:String?
    var bio:String?
    let location:String?
    var blog:String?

    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatar_url = "avatar_url"
        case site_admin = "site_admin"
        case name
        case bio
        case location
        case blog
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.login = try values.decode(String.self, forKey: .login)
        self.avatar_url = try values.decode(URL.self, forKey: .avatar_url)
        self.site_admin = try values.decode(Bool.self, forKey: .site_admin)
        self.name = values.contains(.name) ? try values.decode(String?.self, forKey: .name) : nil
        self.bio = values.contains(.bio) ? try values.decode(String?.self, forKey: .bio) : nil
        self.location = values.contains(.location) ? try values.decode(String?.self, forKey: .location) : nil
        self.blog = values.contains(.blog) ? try values.decode(String?.self, forKey: .blog) : nil
    }
}
