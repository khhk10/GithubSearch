import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatImageView: UIImageView!
    @IBOutlet weak var reciEventLabel: UILabel!
    @IBOutlet weak var reposiNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var eventUrl: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // セルが再利用される時に呼ばれる
    override func prepareForReuse() {
        // 元々入っている情報を再利用時にクリア
        avatImageView.image = nil
    }

}
