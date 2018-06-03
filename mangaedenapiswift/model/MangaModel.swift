//
//  Manga.swift
//  mangaedenapiswift
//
//  Created by Jeremy on 20/05/2018.
//  Copyright © 2018 Jeremy. All rights reserved.
//

import Foundation

class MangaModel: Codable {
    var id: String?
    var title: String?
    var alias: String?
    var image: String?
    var categories: [String]?
    var lastDate: Int64?
    var hits: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id = "i"
        case title = "t"
        case alias = "a"
        case image = "im"
        case categories = "c"
        case lastDate = "ld"
        case hits = "h"
    }
    
    init(jsonData: [String: Any]) {
        self.id = jsonData["i"] as? String
        self.title = jsonData["t"] as? String
        self.alias = jsonData["a"] as? String
        self.image = jsonData["im"] as? String
        self.categories = jsonData["c"] as? [String]
        self.lastDate = jsonData["ld"] as? Int64
        self.hits = jsonData["h"] as? Int64
    }
}
