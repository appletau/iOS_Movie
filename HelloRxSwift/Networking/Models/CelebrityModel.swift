//
//  Celebrity.swift
//  HelloRxSwift
//
//  Created by ST_Ben.Huang 黃韋韜 on 2020/3/25.
//  Copyright © 2020 ST_Ben.Huang 黃韋韜. All rights reserved.
//

import Foundation

struct Celebrity:Codable {
    let id:String?
    let name:String?
    let name_en:String?
    let alt:URL?
    let avatars:Dictionary<String,URL>?
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = values.contains(.id) ? try values.decode(String?.self, forKey: .id) : ""
        self.name = values.contains(.name) ? try values.decode(String?.self, forKey: .name) : ""
        self.name_en = values.contains(.name_en) ? try values.decode(String?.self, forKey: .name_en) : ""
        self.alt = values.contains(.alt) ? try values.decode(URL?.self, forKey: .alt) : URL(fileURLWithPath: "")
        self.avatars = values.contains(.avatars) ? try values.decode(Dictionary<String,URL>?.self, forKey: .avatars) : [:]
    }
}
