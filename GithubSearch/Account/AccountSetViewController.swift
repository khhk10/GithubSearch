//
//  AccountSetViewController.swift
//  GithubSearch
//
//  Created by 池田昂平 on 2019/06/04.
//  Copyright © 2019年 池田昂平. All rights reserved.
//

import UIKit

class AccountSetViewController: UIViewController {
    
    let username = "khhk10"
    let password = "pass"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // リクエストURL
        let requestUrl = "https://api.github.com/user"
        
        // リクエスト
        request(requestUrl: requestUrl)
    }
    
    // リクエストURLの生成
    /*
    func createRequestUrl(parameter: [String: String]) -> String {
        var parameterString = ""
        
        for key in parameter.keys {
            // 値の取り出し
            guard let value = parameter[key] else {
                continue
            }
            
            // 連結に"&"
            if parameterString.lengthOfBytes(using: String.Encoding.utf8) > 0 {
                parameterString += "&"
            }
            
            // エンコード結果の型チェック
            guard let encodeValue = encodeParameter(key: key, value: value) else {
                // nilのとき
                continue
            }
            
            parameterString += encodeValue
        }
        let requestUrl = entryUrl + "?" + parameterString
        return requestUrl
    }*/
    
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // 生成失敗
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        guard let credentialData = "\(username):\(password)".data(using: String.Encoding.utf8) else {
            // 失敗
            return
        }
        // base64, utf8 encoded data
        let credential = credentialData.base64EncodedData(options: [])
        let basicData = "Basic \(credential)"
        // ヘッダーフィールドに値をセット
        request.setValue(basicData, forHTTPHeaderField: "Authorization")
        
        // リクエスト実行
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // エラーチェック
            guard error == nil else {
                return
            }
            
            // データの中身をチェック
            guard let data = data else {
                // データなし
                return
            }
            
            do {
                // JSONデータをデコード
                // let decodedData = try JSONDecoder().decode(ItemSearchResultSet.self, from: data)
                print("##data: \(data)")
                
            } catch let error {
                print("##error: \(error)")
            }
        }
        // 通信開始
        task.resume()
    }
}
