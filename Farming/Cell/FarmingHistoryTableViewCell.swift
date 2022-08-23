//  Copyright (c) 2021, Castcle and/or its affiliates. All rights reserved.
//  DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
//
//  This code is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License version 3 only, as
//  published by the Free Software Foundation.
//
//  This code is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
//  version 3 for more details (a copy is included in the LICENSE file that
//  accompanied this code).
//
//  You should have received a copy of the GNU General Public License version
//  3 along with this work; if not, write to the Free Software Foundation,
//  Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
//
//  Please contact Castcle, 22 Phet Kasem 47/2 Alley, Bang Khae, Bangkok,
//  Thailand 10160, or visit www.castcle.com if you need additional information
//  or have any questions.
//
//  FarmingHistoryTableViewCell.swift
//  Farming
//
//  Created by Castcle Co., Ltd. on 28/3/2565 BE.
//

import UIKit
import Core
import Networking

class FarmingHistoryTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var castcleIdLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var contentImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var balanceTitleLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var lineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.avatarImage.circle()
        self.avatarImage.image = UIImage.Asset.userPlaceholder
        self.contentImage.image = UIImage.Asset.placeholder
        self.lineView.backgroundColor = UIColor.Asset.lineGray
        self.displayNameLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.displayNameLabel.textColor = UIColor.Asset.white
        self.castcleIdLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.castcleIdLabel.textColor = UIColor.Asset.white
        self.balanceTitleLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.balanceTitleLabel.textColor = UIColor.Asset.white
        self.balanceLabel.font = UIFont.asset(.regular, fontSize: .body)
        self.balanceLabel.textColor = UIColor.Asset.lightBlue
        self.dateLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.dateLabel.textColor = UIColor.Asset.white
        self.messageLabel.font = UIFont.asset(.regular, fontSize: .small)
        self.messageLabel.textColor = UIColor.Asset.white
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configCell(farming: Farming) {
        self.balanceLabel.text = "\(farming.balance.farming) CAST"
        self.dateLabel.text = "\(farming.farmingDateDisplay.dateToString()) \(farming.farmingDateDisplay.timeToString())"
        let author = ContentHelper.shared.getAuthorRef(id: farming.content.authorId)
        self.displayNameLabel.text = author?.displayName ?? "Castcle"
        self.castcleIdLabel.text = author?.castcleId ?? "@castcle"
        self.messageLabel.text = (farming.content.message.isEmpty ? "N/A" : farming.content.message)
        let authorAvatarUrl = URL(string: author?.avatar ?? "")
        self.avatarImage.kf.setImage(with: authorAvatarUrl, placeholder: UIImage.Asset.userPlaceholder, options: [.transition(.fade(0.35))])
        if let imageUrl = farming.content.photo.first {
            let url = URL(string: imageUrl.thumbnail)
            self.contentImage.kf.setImage(with: url, placeholder: UIImage.Asset.placeholder, options: [.transition(.fade(0.35))])
        } else {
            self.contentImage.image = UIImage.Asset.placeholder
        }
    }
}
