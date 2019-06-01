//
//  SearchItemTableViewController.swift
//  MySearchApp3
//
//  Created by 池田昂平 on 2019/05/26.
//  Copyright © 2019年 池田昂平. All rights reserved.
//

import UIKit

class SearchItemTableViewController: UITableViewController, UISearchBarDelegate{
    
    var itemDataArray = [RepoItem]()
    
    var imageCache = NSCache<AnyObject, UIImage>()
    
    // let appid = "dj00aiZpPWdoQW91eGRFY1RYZCZzPWNvbnN1bWVyc2VjcmV0Jng9NmQ-"
    // let entryUrl: String = "https://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch"
    let entryUrl: String = "https://api.github.com/search/repositories"
    
    // let priceFormat = NumberFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 価格のフォーマット
        // priceFormat.numberStyle = .currency
        // priceFormat.currencyCode = "JPY"
    }
    
    // UISearchBarDelegateの実装
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // 入力文字の取り出し
        guard let inputText = searchBar.text else {
            // 入力文字なし
            return
        }
        
        // 入力文字数のチェック
        guard inputText.lengthOfBytes(using: String.Encoding.utf8) > 0 else {
            // 0文字未満
            return
        }
        
        // 保持している商品を一旦削除
        itemDataArray.removeAll()
        
        // パラメータ
        //let parameter = ["appid": appid, "query": inputText]
        let parameter = ["q": inputText]
        
        // パラメータをエンコードしたURLを生成する
        let requestUrl = createRequestUrl(parameter: parameter)
        
        // APIをリクエストする
        request(requestUrl: requestUrl)
        
        // キーボードを閉じる
        searchBar.resignFirstResponder()
    }
    
    // パラメータのエンコード
    func encodeParameter(key: String, value: String) -> String? {
        // 値のエンコード
        guard let escapedValue = value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            // エンコード失敗
            return nil
        }
        
        // エンコードした値をkey=valueの形式で返却する
        return "\(key)=\(escapedValue)"
    }
    
    // リクエストURLの生成
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
    }
    
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // エラーチェック
            guard error == nil else {
                // アラートを出す
                let alert = UIAlertController(title: "エラー", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                // UIに関する処理はメインスレッド上で行う
                DispatchQueue.main.async {
                    super.present(alert, animated: true, completion: nil)
                }
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
                
                let decodedData = try JSONDecoder().decode(RepositorySearchResult.self, from: data)
                
                // [itemData]を格納
                // self.itemDataArray.append(contentsOf: decodedData.resultSet.firstObject.result.items)
                
                // 配列[RepoItem]を格納
                self.itemDataArray.append(contentsOf: decodedData.items)
                
            } catch let error {
                print("##error: \(error)")
            }
            
            // テーブルの描画処理を更新
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemDataArray.count
    }
    
    // テーブルビューセル
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        
        let itemData = itemDataArray[indexPath.row]
        
        // 商品名, 価格
        /*
        cell.itemTitleLabel.text = itemData.name
        let number = NSNumber(integerLiteral: Int(itemData.priceInfo.price!)!)
        cell.itemPriceLabel.text = priceFormat.string(from: number)
         
        // 商品のURL
        //cell.itemUrl = itemData.url
        */
        
        // レポジトリ名、説明文
        cell.itemTitleLabel.text = itemData.fullName
        cell.itemPriceLabel.text = itemData.description
        cell.itemStarLabel.text = String(itemData.stargazersCount)
        cell.itemProgLangLabel.text = itemData.language
        
        // レポジトリのURL
        cell.itemUrl = itemData.htmlUrl
        
        
        // 画像のURL
        /*
        guard let itemImageUrl = itemData.imageInfo.medium else {
            // 画像なし商品
            return cell
        }
        */
        
        guard let itemImageUrl = itemData.owner.avatarUrl else {
            // 画像なし
            return cell
        }
        
        // キャッシュ画像あるかどうか
        if let chacheImage = imageCache.object(forKey: itemImageUrl as AnyObject) {
            // 画像を設定
            cell.itemImageView.image = chacheImage
            return cell
        }
        
        // キャッシュがない場合 -> ダウンロード
        guard let url = URL(string: itemImageUrl) else {
            // URLを生成できなかった
            return cell
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // エラーチェック
            guard error == nil else {
                return
            }
            
            // データチェック
            guard let data = data else {
                // データが存在しない
                return
            }
            
            // UIImage生成
            guard let image = UIImage(data: data) else {
                // UIImageを生成できなかった
                return
            }
            
            // キャッシュに画像を登録
            self.imageCache.setObject(image, forKey: itemImageUrl as AnyObject)
            
            // 画像はメインそスレッド上で設定する
            DispatchQueue.main.async {
                cell.itemImageView.image = image
            }
        }
        // 通信開始
        task.resume()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? ItemTableViewCell {
            if let webViewController = segue.destination as? WebViewController {
                // 商品ページのURLを設定する
                webViewController.itemUrl = cell.itemUrl
            }
        }
    }

}
