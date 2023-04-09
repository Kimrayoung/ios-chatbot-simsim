//
//  MeCell.swift
//  ChatBotMission-alone
//
//  Created by 김라영 on 2023/02/02.
//

import Foundation
import UIKit

class MeCell: UITableViewCell {
    @IBOutlet weak var content: PadddingLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.content.layer.masksToBounds = true
        self.content .layer.cornerRadius = 21
    }
}
