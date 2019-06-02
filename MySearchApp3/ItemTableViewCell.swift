//
//  ItemTableViewCell.swift
//  MySearchApp3
//
//  Created by 池田昂平 on 2019/05/26.
//  Copyright © 2019年 池田昂平. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemStarLabel: UILabel!
    @IBOutlet weak var itemProgLangLabel: UILabel!
    
    @IBOutlet weak var starImage: UIImageView!
    
    var itemUrl: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // セルが再利用される時に呼ばれる
    override func prepareForReuse() {
        // 元々入っている情報を再利用時にクリア
        itemImageView.image = nil
    }
}
