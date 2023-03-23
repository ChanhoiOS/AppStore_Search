//
//  SearchResultCell.swift
//  AppStore_KAKAOBANK
//
//  Created by 이찬호 on 2023/03/20.
//

import UIKit
import Cosmos

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var appIconImage: UIImageView!
    @IBOutlet weak var screenShot_1: UIImageView!
    @IBOutlet weak var screenShot_2: UIImageView!
    @IBOutlet weak var screenShot_3: UIImageView!
    @IBOutlet weak var stateBtn: UIButton!
    
    @IBOutlet weak var cosmosView: CosmosView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stateBtn.layer.cornerRadius = 15
        stateBtn.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
