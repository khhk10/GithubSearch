import UIKit
import WebKit

class NewsDetailViewController: UIViewController {
    
    var webUrl: String?

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // User-AgentをiPhoneに設定する
        webView.customUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 11_0_1 like Mac OS X) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Mobile/15A402 Safari/604.1"
        
        // urlを読み込ませてWebページを表示
        guard let webUrl = webUrl else {
            return
        }
        guard let url = URL(string: webUrl) else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }

}
