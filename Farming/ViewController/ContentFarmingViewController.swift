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
//  ContentFarmingViewController.swift
//  Farming
//
//  Created by Castcle Co., Ltd. on 28/3/2565 BE.
//

import UIKit
import Core
import XLPagerTabStrip
import Defaults

class ContentFarmingViewController: ButtonBarPagerTabStripViewController {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupButtonBar()
    }

    private func setupButtonBar() {
        settings.style.buttonBarBackgroundColor = UIColor.Asset.darkGraphiteBlue
        settings.style.buttonBarItemBackgroundColor = UIColor.Asset.darkGraphiteBlue
        settings.style.selectedBarBackgroundColor = UIColor.Asset.lightBlue
        settings.style.buttonBarItemTitleColor = UIColor.Asset.white
        settings.style.selectedBarHeight = 4
        settings.style.buttonBarItemFont = UIFont.asset(.bold, fontSize: .body)
        settings.style.buttonBarHeight = 60.0

        self.changeCurrentIndexProgressive = { (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, _, _, _) -> Void in
            oldCell?.label.textColor = UIColor.Asset.white
            newCell?.label.textColor = UIColor.Asset.lightBlue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavBar()
        Defaults[.screenId] = ""
    }

    func setupNavBar() {
        self.customNavigationBar(.secondary, title: "Content Farming")
    }

    // MARK: - PagerTabStripDataSource
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let vc1 = FarmingOpener.open(.farmingHistory(FarmingHistoryViewModel(type: .active))) as? FarmingHistoryViewController
        vc1?.pageIndex = 0
        vc1?.pageTitle = "Active Farming"
        let activeFarming = vc1 ?? FarmingHistoryViewController()

        let vc2 = FarmingOpener.open(.farmingHistory(FarmingHistoryViewModel(type: .history))) as? FarmingHistoryViewController
        vc2?.pageIndex = 1
        vc2?.pageTitle = "Farming History"
        let farmingHistory = vc2 ?? FarmingHistoryViewController()

        return [activeFarming, farmingHistory]
    }
}
