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
//  FarmingHistoryViewController.swift
//  Farming
//
//  Created by Castcle Co., Ltd. on 28/3/2565 BE.
//

import UIKit
import Core
import XLPagerTabStrip

class FarmingHistoryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var viewModel = FarmingHistoryViewModel()
    var pageIndex: Int = 0
    var pageTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.Asset.darkGraphiteBlue
        self.configureTableView()
    }
    
    func configureTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: FarmingNibVars.TableViewCell.activeFarming, bundle: ConfigBundle.farming), forCellReuseIdentifier: FarmingNibVars.TableViewCell.activeFarming)
        self.tableView.register(UINib(nibName: FarmingNibVars.TableViewCell.farmingHistory, bundle: ConfigBundle.farming), forCellReuseIdentifier: FarmingNibVars.TableViewCell.farmingHistory)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
    }
}

extension FarmingHistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.viewModel.farmingHistoryType == .active {
            return 2
        } else if self.viewModel.farmingHistoryType == .history {
            return 3
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.viewModel.farmingHistoryType == .active {
            let cell = tableView.dequeueReusableCell(withIdentifier: FarmingNibVars.TableViewCell.activeFarming, for: indexPath as IndexPath) as? ActiveFarmingTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            return cell ?? ActiveFarmingTableViewCell()
        } else if self.viewModel.farmingHistoryType == .history {
            let cell = tableView.dequeueReusableCell(withIdentifier: FarmingNibVars.TableViewCell.farmingHistory, for: indexPath as IndexPath) as? FarmingHistoryTableViewCell
            cell?.backgroundColor = UIColor.Asset.darkGray
            return cell ?? FarmingHistoryTableViewCell()
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension FarmingHistoryViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo.init(title: pageTitle ?? "Tab \(pageIndex)")
    }
}
