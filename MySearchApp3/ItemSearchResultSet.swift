//
//  ItemSearchResultSet.swift
//  MySearchApp3
//
//  Created by 池田昂平 on 2019/05/26.
//  Copyright © 2019年 池田昂平. All rights reserved.
//

class ItemSearchResultSet: Codable {
    var resultSet: ResultSet
    
    private enum CodingKeys: String, CodingKey {
        case resultSet = "ResultSet"
    }
}

class ResultSet: Codable {
    var firstObject: FirstObject
    
    private enum CodingKeys: String, CodingKey {
        case firstObject = "0"
    }
}

class FirstObject: Codable {
    var result: Result
    
    private enum CodingKeys: String, CodingKey {
        case result = "Result"
    }
}

class Result: Codable {
    var items: [ItemData] = [ItemData]()
    
    required init(from decoder: Decoder) throws {
        // コンテナ
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // コンテナのキー取得。数値の昇順でソート
        let keys = container.allKeys.sorted {
            Int($0.rawValue)! < Int($1.rawValue)!
        }
        // キーを使用して一件ずつ取り出す
        for key in keys {
            let item = try container.decode(ItemData.self, forKey: key)
            items.append(item)
        }
    }
    
    // エンコード
    func encode(to encoder: Encoder) throws {
        
    }
    
    // キー
    private enum CodingKeys: String, CodingKey {
        case hit0 = "0"
        case hit01 = "1"
        case hit02 = "2"
        case hit03 = "3"
        case hit04 = "4"
        case hit05 = "5"
        case hit06 = "6"
        case hit07 = "7"
        case hit08 = "8"
        case hit09 = "9"
        case hit10 = "10"
        case hit11 = "11"
        case hit12 = "12"
        case hit13 = "13"
        case hit14 = "14"
        case hit15 = "15"
        case hit16 = "16"
        case hit17 = "17"
        case hit18 = "18"
        case hit19 = "19"
        case hit20 = "20"
    }
}

class ItemData: Codable {
    var name: String = ""
    var url: String = ""
    
    var imageInfo: ImageInfo = ImageInfo()
    
    class ImageInfo: Codable {
        // 商品画像のURL
        var medium: String?
        
        private enum CodingKeys: String, CodingKey {
            case medium = "Medium"
        }
    }
    
    var priceInfo: PriceInfo = PriceInfo()
    
    class PriceInfo: Codable {
        var price: String?
        
        private enum CodingKeys: String, CodingKey {
            case price = "_value"
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case name = "Name"
        case url = "Url"
        case imageInfo = "Image"
        case priceInfo = "Price"
    }
}
