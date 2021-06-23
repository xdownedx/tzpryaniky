//
//  ModelData.swift
//  testForPryaniky
//
//  Created by adeleLover on 18.06.2021.
//

import Foundation
import Alamofire
import SwiftyJSON

struct dataFromJson{
    var name: String
    var data: nestedData

    init(json:JSON){
        self.name = json["name"].stringValue
        self.data = nestedData(json: json["data"])
    }
}

struct nestedData{
    var url: String?
    var text: String?
    var selectedId: Int?
    var variants: [variantForSelector]?

    init(json:JSON) {
        self.url = json["url"].stringValue
        self.text = json["text"].stringValue
        self.selectedId = json["selectedId"].intValue
        self.variants = json["variants"].arrayValue.map { variantForSelector($0) }
    }
}

struct variantForSelector{
    var id: Int
    var text: String

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.text = json["text"].stringValue
    }
}
