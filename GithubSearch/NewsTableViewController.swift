import UIKit

class NewsTableViewController: UITableViewController {
    
    // ユーザが受け取るイベント
    var reciEventArray = [RecievedEventItem]()
    
    // ユーザID、GETのURL
    let username: String = "khhk10"
    var entryUrl: String = "https://api.github.com/users"
    
    // キャッシュ
    var imageCache = NSCache<AnyObject, UIImage>()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // URL
        entryUrl += "/" + username + "/received_events"
        
        // UIRefreshControlオブジェクトを指定
        tableView.refreshControl = UIRefreshControl()
        
        // セレクタを使ったメソッド呼び出し
        let selector = #selector(handleRefresh(_:))
        tableView.refreshControl?.addTarget(self, action: selector, for: .valueChanged)
        
        // リクエスト
        request(requestUrl: entryUrl)
    }
    
    // リフレッシュ処理
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        
        // リクエスト
        request(requestUrl: entryUrl)
        
        // refresh controlを終了
        DispatchQueue.main.async {
            sender.endRefreshing()
        }
    }
    
    // リクエスト
    func request(requestUrl: String) {
        // URL生成
        guard let url = URL(string: requestUrl) else {
            // 生成失敗
            return
        }
        
        let request = URLRequest(url: url)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            // エラーチェック
            guard error == nil else {
                let alert = UIAlertController(title: "エラー", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                // UIに関する処理はメインスレッドで実行
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
                let decodedData = try JSONDecoder().decode([RecievedEventItem].self, from: data)
                
                // 一度配列の中身を空にする
                if self.reciEventArray.count > 0 {
                    self.reciEventArray.removeAll()
                }
                
                // 配列[RecievedEventItem]を格納
                self.reciEventArray.append(contentsOf: decodedData)
                
            } catch let error {
                print("#error: \(error)")
            }
            
            // テーブルの描画処理を更新
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        // 通信開始
        task.resume()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reciEventArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "newsItemCell", for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        
        let eventItem = reciEventArray[indexPath.row]
        
        // イベント元のユーザ
        guard let actor = eventItem.actor.name else {
            cell.reciEventLabel.text = nil
            return cell
        }
        
        // イベントタイプ
        guard let eventType = eventItem.type else {
            cell.reciEventLabel.text = nil
            return cell
        }
        
        // 時間
        guard let time = eventItem.time else {
            cell.timeLabel.text = nil
            return cell
        }
        
        // ISO8601の時間形式 -> Dateオブジェクト
        let dateFormat = ISO8601DateFormatter()
        if let date = dateFormat.date(from: time) {
            // インターバル日数を取得
            let interval = getIntervalTime(date: date)
            cell.timeLabel.text = interval
            // cell.timeLabel.text = time
        }
        
        // イベントの内容
        let eventStr = eventString(eventType: eventType)
        cell.reciEventLabel.text = actor + "  " + eventStr
        cell.reposiNameLabel.text = eventItem.repository.name
        
        // 画像URL
        var imageUrl: String
        
        guard let itemImageUrl = eventItem.actor.avatarUrl else {
            // 画像なし
            return cell
        }
        imageUrl = itemImageUrl
        
        // キャッシュがあるかどうか
        if let cacheImage = imageCache.object(forKey: imageUrl as AnyObject) {
            // 画像を設定
            cell.avatImageView.image = cacheImage
            return cell
        }
        
        // キャッシュがない -> ダウンロード
        downloadImage(imageUrl: imageUrl, cell: cell)

        return cell
    }
    
    // イベントタイプ -> イベント内容を返す
    func eventString(eventType: String) -> String {
        
        switch eventType {
        case "WatchEvent":
            return "starred"
        case "ForkEvent":
            return "forked"
        case "PublicEvent":
            return "made public"
        default:
            return eventType
        }
    }
    
    // インターバル計算
    func getIntervalTime(date: Date) -> String {
        // 秒数
        let secondInterval = date.timeIntervalSinceNow
        // 日数
        let dayInterval = Int(fabs(secondInterval / 86400))
        
        if dayInterval < 1 {
            // 今日
            let hourString = String(Int(fabs(secondInterval / 3600)))
            return hourString + " hours ago"
            
        } else if dayInterval < 2 {
            // 昨日
            return "Yesterday"
            
        } else {
            // 数日前
            return String("\(dayInterval)") + " days ago"
        }
    }
    
    // 画像をダウンロード
    func downloadImage(imageUrl: String, cell: NewsTableViewCell) {
        
        guard let url = URL(string: imageUrl) else {
            // URLを生成できなかった
            return
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
            self.imageCache.setObject(image, forKey: imageUrl as AnyObject)
            
            // 画像はメインスレッド上で設定
            DispatchQueue.main.async {
                cell.avatImageView.image = image
            }
        }
        // 通信開始
        task.resume()
    }


}
