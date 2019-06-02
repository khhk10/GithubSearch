import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // 商品ページのURL
    var itemUrl: String?

    // 商品ページを表示するWebView
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User-AgentをiPhoneに設定する
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0_1 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A402 Safari/604.1"
        
        // itemUrlの中身をチェック
        guard let itemUrl = itemUrl else {
            return
        }
        
        guard let url = URL(string: itemUrl) else {
            // URLの生成に失敗
            return
        }
        
        // URLを読み込んでwebページを表示する
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
